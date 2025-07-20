# TypeScript Coding Standards

## Core Principles
1. Use `let` and `const` instead of `var`
2. Prefer `const` for immutable variables
3. Group consecutive declarations in one statement
4. Avoid multi-line `const` declarations
5. Use template literals when they improve readability
6. Avoid multi-line template literals
7. Use `String()` for implicit string conversion
8. Prefer `async/await` over Promise chaining
9. Use `Promise.all()` for concurrent async operations

## Destructuring
- Basic object/array destructuring: ✅
- Array destructuring with rest: ✅
- Object destructuring with rest: ❌ (risky)
- Array destructuring with ignores: ✅ (caution)
- Renaming while destructuring: ✅
- Deep data destructuring: ❌ (not readable)

## Functions
- Use rest parameters instead of `arguments`
- Use parentheses around arrow function parameters
- No implicit returns in arrow functions
- No arrow functions as class properties
- Space before and after arrow in arrow functions

## Error Handling
- Prefer `instanceof` for error checking
- Avoid `instanceof` in ES5 transpiled code
- Be cautious with string-based error checks

## Types
- No implicit `any` types
- Explicit types for exported variables
- Explicit return types for functions
- Use primitive types (string, number, boolean)
- No space between variable and colon in type declarations
- One space between colon and type

## TypeScript Features
- Rest parameters: ✅
- Spread operator: ✅
- Default parameters: ✅
- Iterators and generators: ✅ (caution)
- Parameter properties: ✅ (private only)