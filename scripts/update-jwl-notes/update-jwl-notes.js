const fs = require('fs');
const path = require('path');
const uuid = require('uuid');
const sqlite = require('sqlite');
const sqlite3 = require('sqlite3');
const matter = require('gray-matter');
const { execSync } = require('child_process');

const dbPath = process.argv[2];

if (!dbPath) {
    console.error("Usage: node process_notes.js <path_to_db>");
    process.exit(1);
}

// Verify the database file exists and is accessible
if (!fs.existsSync(dbPath)) {
    console.error(`Database file does not exist at path: ${dbPath}`);
    process.exit(1);
}

// Function to format content using dprint
function formatContent(content) {
    return execSync('dprint fmt --stdin .md', { input: content }).toString();
}

// Function to extract citations from markdown content
function extractCitations(content) {
    const regex = /\[\[_bible\/(\d+)\s([0-9 A-Za-z]+)\s(\d+)#?(\d*)\|?.*?\]\]/g;
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

// Function to extract title from markdown content
function extractTitle(content) {
    const parsed = matter(content);
    if (parsed.data.title) {
        return parsed.data.title;
    }

    const titleMatch = content.match(/^#\s+(.+)/m);
    return titleMatch ? titleMatch[1] : '';
}

// Function to remove the title from the content
function removeTitleFromContent(content, title) {
    const titleRegex = new RegExp(`^#\\s+${title.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')}`, 'm');
    return content.replace(titleRegex, '').trim();
}

// Function to replace wiki links with display text
function replaceWikiLinks(content) {
    const wikiLinkRegex = /\[\[.*\|(.*)\]\]/g;
    return content.replace(wikiLinkRegex, '$1');
}

// Function to remove front matter from the content
function removeFrontMatter(content) {
    const parsed = matter(content);
    return parsed.content;
}

// Function to process markdown file
async function processMarkdownFile(db, filePath) {
    let content = fs.readFileSync(filePath, 'utf8');

    // Extract citations
    const citations = extractCitations(content);

    if (!citations.length) {
        return;
    }

    // Extract title
    const title = extractTitle(content);

    // Remove the title from the content
    content = removeTitleFromContent(content, title);

    // Replace wiki links with display text
    content = replaceWikiLinks(content);

    // Remove front matter
    content = removeFrontMatter(content);

    // Format content using dprint
    content = formatContent(content);

    for (const citation of citations) {
        console.log(`Inserting note at ${JSON.stringify(citation)} for ${filePath}`);

        const { bookNumber, chapterNumber, verseNumber } = citation;
        const noteGuid = uuid.v4();

        // Use 1 as the fallback value for blockIdentifier
        const blockIdentifier = verseNumber || 1;

        // Insert the location into the database
        const { lastID: locationID } = await db.run(
            `INSERT INTO Location (BookNumber, ChapterNumber, KeySymbol, Type) 
            VALUES (?, ?, ?, ?)`,
            Number(bookNumber), Number(chapterNumber), 'nwtsty', 0
        );

        // Insert the note into the database
        await db.run(
            `INSERT INTO Note (Guid, Title, Content, LastModified, Created, LocationId, BlockIdentifier, BlockType) 
            VALUES (?, ?, ?, datetime('now'), datetime('now'), ?, ?, 2)`,
            noteGuid, title, content, locationID, blockIdentifier
        );

    }
}

// Function to clear existing notes from the database
async function clearNotes(db) {
    await db.run(
        `DELETE FROM Note WHERE LocationId IN (SELECT LocationId FROM Location WHERE KeySymbol IN ('Rbi8', 'nwt', 'nwtsty'))`
    );
}

// Process each markdown file
async function processMarkdownFiles(db) {
    const notesDir = path.join(process.env.HOME, 'notes', 'notes');
    const files = fs.readdirSync(notesDir).filter(file => file.endsWith('.md'));

    for (const file of files) {
        const filePath = path.join(notesDir, file);
        if (filePath) {
            await processMarkdownFile(db, filePath);
        }
    }
}

(async () => {
    try {
        const db = await sqlite.open({ filename: dbPath, driver: sqlite3.Database });
        await clearNotes(db);
        await processMarkdownFiles(db);
        await db.close();
    } catch (error) {
        console.error('Error processing files:', error);
    }
})();
