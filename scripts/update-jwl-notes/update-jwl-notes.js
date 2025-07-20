const fs = require('fs/promises'),
      path = require('path'),
      uuid = require('uuid'),
      sqlite = require('sqlite'),
      sqlite3 = require('sqlite3'),
      minimist = require('minimist'),
      matter = require('gray-matter'),
      { execSync } = require('child_process');

const ALLOWED_ACTIONS = [ 'import', 'export', 'clear' ],
      argv = minimist(process.argv.slice(2), { string: [ 'action', 'path' ] })

if (!argv.path || !ALLOWED_ACTIONS.includes(argv.action)) {
   console.info(`Please provide --path <PATH_TO_DB> and --action <${ALLOWED_ACTIONS.join('|')}>`)
   process.exit(1);
}

function formatContent(content) {
   return execSync('dprint fmt --stdin .md', { input: content }).toString().trim();
}

function extractCitations(content) {
   const regex = /\[\[(?:_bible\/)?(\d+)\s([0-9 A-Za-z]+)\s(\d+)#?(\d*)\|?.*?\]\]/g;
   let citations = [];
   let match;

   while ((match = regex.exec(content)) !== null) {
      const [_, bookNumber, bookName, chapterNumber, verseNumber] = match;
      citations.push({
         bookNumber: parseInt(bookNumber, 10),
         chapterNumber: parseInt(chapterNumber, 10),
         verseNumber: verseNumber ? parseInt(verseNumber, 10) : 1
      });
   }

   return citations;
}

function extractTitle(content) {
   const parsed = matter(content);
   if (parsed.data.title) {
      return parsed.data.title;
   }

   const titleMatch = content.match(/^#\s+(.+)/m);
   return titleMatch ? titleMatch[1] : '';
}

function removeTitleFromContent(content, title) {
   const titleRegex = new RegExp(`^#\\s+${title.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')}`, 'm');
   return content.replace(titleRegex, '').trim();
}

function replaceWikiLinks(content) {
   const wikiLinkRegex = /\[\[.*\|(.*)\]\]/g;
   return content.replace(wikiLinkRegex, '$1');
}

function removeFrontMatter(content) {
   const parsed = matter(content);
   return parsed.content;
}

async function processMarkdownFile(db, filePath) {
   let content = await fs.readFile(filePath, 'utf8'),
       { ctime, mtime } = await fs.stat(filePath);

   const citations = extractCitations(content);

   if (!citations.length) {
      return;
   }

   const title = extractTitle(content);

   content = removeTitleFromContent(content, title);
   content = replaceWikiLinks(content);
   content = removeFrontMatter(content);
   content = formatContent(content);

   for (const citation of citations) {
      const { bookNumber, chapterNumber, verseNumber } = citation,
            noteGuid = uuid.v4(),
            blockIdentifier = verseNumber || 1;

      const existingLocation = await db.get(
         `
            SELECT LocationID
               FROM Location
            WHERE BookNumber = ?
               AND ChapterNumber = ?
               AND KeySymbol = ?
               AND MEPSLanguage = ?
               AND Type = ?
         `,
         [ Number(bookNumber), Number(chapterNumber), 'nwtsty', 0, 0 ]);

      let locationID = existingLocation?.LocationId;

      if (!locationID) {
         const location = await db.run(
            `INSERT INTO Location (BookNumber, ChapterNumber, KeySymbol, MEPSLanguage, Type)
               VALUES (?, ?, ?, ?, ?)`,
            Number(bookNumber), Number(chapterNumber), 'nwtsty', 0, 0
         );

         locationID = location.lastID;
      }

      // Insert the note into the database
      await db.run(
         `INSERT INTO Note (Guid, Title, Content, LastModified, Created, LocationId, BlockIdentifier, BlockType)
            VALUES (?, ?, ?, ?, ?, ?, ?, 2)`,
         noteGuid, title, content, ctime.toISOString(), ctime.toISOString(), locationID, blockIdentifier
      );
   }
}

// Function to clear existing notes from the database
async function clearNotes(db) {
   await db.run(
      `DELETE FROM Note WHERE LocationId IN (SELECT LocationId FROM Location WHERE KeySymbol IN ('Rbi8', 'nwt', 'nwtsty'))`
   );
}

const BIBLE_BOOK_MAPPING = {
   1: 'Genesis',
   2: 'Exodus',
   3: 'Leviticus',
   4: 'Numbers',
   5: 'Deuteronomy',
   6: 'Joshua',
   7: 'Judges',
   8: 'Ruth',
   9: '1 Samuel',
   10: '2 Samuel',
   11: '1 Kings',
   12: '2 Kings',
   13: '1 Chronicles',
   14: '2 Chronicles',
   15: 'Ezra',
   16: 'Nehemiah',
   17: 'Esther',
   18: 'Job',
   19: 'Psalms',
   20: 'Proverbs',
   21: 'Ecclesiastes',
   22: 'Song of Solomon',
   23: 'Isaiah',
   24: 'Jeremiah',
   25: 'Lamentations',
   26: 'Ezekiel',
   27: 'Daniel',
   28: 'Hosea',
   29: 'Joel',
   30: 'Amos',
   31: 'Obadiah',
   32: 'Jonah',
   33: 'Micah',
   34: 'Nahum',
   35: 'Habakkuk',
   36: 'Zephaniah',
   37: 'Haggai',
   38: 'Zechariah',
   39: 'Malachi',
   40: 'Matthew',
   41: 'Mark',
   42: 'Luke',
   43: 'John',
   44: 'Acts',
   45: 'Romans',
   46: '1 Corinthians',
   47: '2 Corinthians',
   48: 'Galatians',
   49: 'Ephesians',
   50: 'Philippians',
   51: 'Colossians',
   52: '1 Thessalonians',
   53: '2 Thessalonians',
   54: '1 Timothy',
   55: '2 Timothy',
   56: 'Titus',
   57: 'Philemon',
   58: 'Hebrews',
   59: 'James',
   60: '1 Peter',
   61: '2 Peter',
   62: '1 John',
   63: '2 John',
   64: '3 John',
   65: 'Jude',
   66: 'Revelation'
}

async function getBibleNotesFromDB(db) {
   const notes = await db.all(`
      SELECT
       BookNumber,
       ChapterNumber,
       Note.BlockIdentifier,
       Note.Title,
       Content,
       GROUP_CONCAT(Tag.Name, ', ') AS tag_titles
      FROM
       Note
      JOIN
       Location ON Note.LocationId = Location.LocationId
      LEFT JOIN
       TagMap ON Note.NoteId = TagMap.NoteId
      LEFT JOIN
       Tag ON TagMap.TagId = Tag.TagId
      WHERE
       LOWER(Location.KeySymbol) IN ('rbi8', 'nwt', 'nwtsty')
      GROUP BY
       Note.NoteId
      ORDER BY BookNumber ASC, ChapterNumber ASC, Note.BlockIdentifier ASC
   `);

   return notes.map((note) => {
      return {
         citation: `${BIBLE_BOOK_MAPPING[note.BookNumber]} ${note.ChapterNumber}:${note.BlockIdentifier}`,
         title: note.Title ? note.Title : undefined,
         content: note.Content ? note.Content : undefined,
         tags: note.tag_titles ? note.tag_titles.split(', ') : undefined,
      };
   });
}

async function processMarkdownFiles(db) {
   const notesDir = path.join(process.env.HOME, 'notes', 'notes'),
         files = (await fs.readdir(notesDir)).filter(file => file.endsWith('.md'));

   for (const file of files) {
      const filePath = path.join(notesDir, file);

      if (filePath) {
         await processMarkdownFile(db, filePath);
      }
   }
}

(async () => {
   try {
      const db = await sqlite.open({ filename: argv.path, driver: sqlite3.Database }),
            action = argv.action.toLowerCase();

      if (action === 'clear') {
         await clearNotes(db);
      } else if (action === 'import') {
         await processMarkdownFiles(db);
      } else if (action === 'export') {
         console.log(JSON.stringify(await getBibleNotesFromDB(db), null, 3));
      }

      await db.close();
   } catch (error) {
      console.error('Error processing files:', error);
   }
})();
