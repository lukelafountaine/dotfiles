# Silvermine Coding Standards (LLM-Optimized)

## Core Principles

   * Readability and clarity over brevity
   * Consistent formatting that represents logical structure
   * Follow existing patterns in codebase
   * Separate formatting-only changes from functional changes

## Naming Conventions

### Classes

   * **PascalCase** nouns (e.g., `UserAccount`)
   * Singular form, match table names when applicable

### Functions

   * **Static functions**: snake_case (e.g., `get_user_data`)
   * **Instance functions**: camelCase (e.g., `getUserData`)
   * **Private/protected**: camelCase with underscore prefix (e.g., `_privateMethod`)
   * Name describes complete purpose:
      * Return single value: `get` + column name
      * Return single record: `get` + table name
      * Return multiple rows: `list` + table name
      * No return: strong verb + noun
      * Boolean: start with "is" (e.g., `isPublished`)

### Variables

   * **Static variables**: snake_case
   * **Constants**: UPPER_SNAKE_CASE
   * **Instance/scoped variables**: camelCase
   * **Private/protected**: camelCase with underscore prefix
   * **Arrays**: plural form (except associative arrays)
   * **Booleans**: imply true/false naturally
   * 4-20 characters optimal, specific purpose
   * No Hungarian notation

### Files

   * **Classes**: PascalCase matching class name (e.g., `User.js`)
   * **Functions/objects**: kebab-case (e.g., `my-function.js`)
   * **Tests**: `ClassTheyAreTesting.test.js`

## Formatting Rules

### Indentation

   * **3 spaces** (never tabs)
   * Wrapped lines: indent one level from first line
   * Variable declarations: don't wrap in var blocks (except const)
   * Chained functions: indent one level from chain start

### Braces & Structure

   * Opening brace at end of line (K&R style)
   * Always use braces for conditionals/loops (even single line)
   * One blank line between unrelated statements
   * One-two blank lines between functions

### Spacing & Operators

   * Space after control structures: `if (condition)`
   * No space between function name and parenthesis: `myFunction()`
   * Space around operators (except unary: `!`, `++`, `--`)
   * Space after commas in arrays/arguments
   * Empty arrays/objects: no spaces (`[]`, `{}`)
   * Multi-line arrays/objects: always trailing comma

### Parentheses

   * Use for clarity even when not required
   * No spaces between nested parentheses

## Function Documentation

Required JSDoc format:

```javascript
/**
 * Description of function purpose
 *
 * @param Type $param - description (optional, default value)
 * @return Type - description of return value
 */
```

## Control Structures

   * Avoid deep nesting (low cyclomatic complexity)
   * Most common case in `if` (not `else`)
   * Use positive logic over negative
   * Break complex conditions into variables/functions
   * Check error conditions early with early returns

## Variable Best Practices

   * Declare in lowest possible scope
   * Declare at top of scope before statements
   * Initialized variables before uninitialized
   * Avoid modifying input parameters (except immediate sanitization)
   * Keep reference distance short
   * Avoid global variables (constants only)
   * Always sanitize user input

## Abbreviations & Acronyms

   * Use sparingly, prioritize readability
   * Be consistent across codebase
   * Acronyms: ALL_CAPS except when first letter of camelCase property
   * Remove non-leading vowels for abbreviations
   * Must be pronounceable

## File Standards

   * End with newline character (not blank line)
   * No Windows line endings
   * No commented-out code without reason
   * Ternary operator only for simple conditions

## Case Definitions

   * **PascalCase**: `ThisIsAnExample`
   * **camelCase**: `thisIsAnExample`
   * **kebab-case**: `this-is-an-example`
   * **snake_case**: `this_is_an_example`
   * **UPPER_SNAKE_CASE**: `THIS_IS_AN_EXAMPLE`
