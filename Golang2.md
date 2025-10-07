# System Architecture

A multi-stage template-based code generation system for creating custom generators. The architecture separates schema definition, data content, and generation logic. The system is implemented in Go but generates loaders that can target any language.

## Bootstrap Process

The system uses a two-stage bootstrap to generate itself.

### Core Generator

The core generator is written in Go in the `gen` directory. Core files are `main.go`, `gen.go`, `run.go`, `structs.go`, and `collect.go`. It reads unit schemas and generates loader code in the target language. The generated loader parses definition files according to the schema.

**Command syntax:**
```bash
go run gen/*.go actor_file schema1.unit,schema2.unit >output
```

### Application Generator

The application generator uses the generated loader to read definition files. Generated files include `run.go` for parsing and `structs.go` for data structures. It validates data against the schema ensuring structural integrity. Actor files drive the code generation or documentation output. This stage can generate any output format from the structured data.

### Bootstrap Benefits

- The generator can regenerate its own loader when schemas change
- New generator applications require no host language coding
- Schema changes automatically propagate through regeneration
- The system is self-documenting through its own documentation generator

### Getting Started

1. Install Go version 1.16 or later
2. Organize files in `gen` directory for bootstrap and `src` for generated code
3. Run `g_struct.act` against `gen.unit` to generate `structs.go`
4. Run `g_run.act` against `gen.unit` to generate `run.go`
5. The generated loader can now process your schemas and definitions

**Example:**
```bash
go run src/*.go myapp.act mydata.def arg2 arg3 >output
```

---

## Program Entry Point

The main function serves as the entry point for generated applications. It orchestrates initialization, loading, and execution phases.

### Command Line Arguments

- First argument specifies the actor file or comma-separated list
- Second argument specifies the data definition file or comma-separated list
- Additional arguments are stored as numbered variables for actor access
- Minimum two arguments required or program exits silently
- Arguments are accessible via `${0}` through `${N}`

### Global Initialization

- Creates new `GlobT` structure to hold all global state
- Sets `Winp` to -1 indicating no current window
- Sets `OutOn` to true enabling output by default
- Initializes `Collect` map for collection storage
- Prepares error counters `LoadErrs` and `RunErrs` to zero

### Execution Flow

1. Calls `loadFiles` for actor file storing in `glob.Acts`
2. Calls `loadFiles` for data file storing in `glob.Dats`
3. Checks if any actors exist in `ApActor` array
4. Creates `KpExtra` with `Names` map for argument storage
5. Stores all command-line arguments in `Names` map by index
6. Calls `NewAct` with first actor name and `run:1` line number
7. Calls `GoAct` to execute the actor with argument context

### Error Handling

- Checks `LoadErrs` and `RunErrs` after execution completes
- Prints error counts using println if any errors occurred
- Calls `os.Exit` with status 1 if errors present
- Exits normally with status 0 if no errors
- Error messages include file names and line numbers

---

## Runtime State

The `GlobT` structure maintains global execution state across all actors.

### Error Tracking

- `LoadErrs` counts errors during file loading and parsing
- `RunErrs` counts errors during actor execution and variable resolution
- Error counters accumulate across all operations
- Non-zero error count causes program exit with status 1

### Data Storage

- `Acts` field holds `ActT` structure with all loaded actors
- `Dats` field holds `ActT` structure with all loaded data nodes
- Each `ActT` contains component arrays and index map
- `ApActor` array specifically holds actor definitions
- The index map provides O(1) lookup by component name key

### Window Management

- `Winp` tracks current window position as integer
- `Wins` array holds `WinT` structures for each window context
- Value -1 indicates no active window
- Windows enable nested execution contexts for complex iteration

### Collections Map

- `Collect` map stores dynamically created collections by name
- Keys are collection names as strings
- Values are `interface{}` allowing any data type
- Collections persist across all actor invocations
- Used for accumulating results and cross-actor communication

### Output Control

- `OutOn` boolean flag enables or disables output generation
- `InOn` boolean flag enables or disables input redirection
- `Ins` is a `strings.Builder` accumulating redirected output
- These support the `Out` and `In` commands for flow control
- Output can be delayed, disabled, or redirected to variables

---

## File Loading Process

The `loadFiles` function coordinates reading and parsing input files.

### File List Processing

- Accepts comma-separated list of file paths as single string
- Splits on comma using `strings.Split` to get individual files
- Processes each file independently in sequence
- Accumulates errors across all files

### File Reading

- Uses `os.ReadFile` to load entire file into memory
- Converts byte array to string for line processing
- Reports file read errors with filename and error message
- Increments error counter for each file that fails to load
- Continues processing remaining files after read errors

### Line Parsing

- Splits file content on newline creating line array
- Calls `LoadData` with lines, target `ActT`, and filename
- `LoadData` iterates lines with loop counter
- Constructs line number as `filename:number` for error reporting
- Removes carriage return characters for cross-platform compatibility

### Index Initialization

- Creates index map in `ActT` before loading any files
- Map stores string keys to integer node identifiers
- Index enables fast lookup of Find and FindIn components
- Reference resolution depends on index for target lookup

### Reference Resolution

- Calls `refs` function after all files loaded
- Resolution happens in multiple passes until stable
- Returns total count of unresolved references
- Error count added to overall `LoadErrs` counter
- Successful resolution required for execution to proceed

---

## Line Processing

`LoadData` processes individual lines from definition files.

### Line Iteration

- Loop variable `i` ranges from 0 to `len(lns) - 1`
- Line number calculated as `i + 1` for human readability
- Constructs `lno` string as `filename:linenumber` for error tracking
- Each line processed independently in sequence

### Line Cleaning

- Removes carriage return characters using `strings.ReplaceAll`
- Handles files with Windows CRLF or Unix LF line endings
- Ensures consistent line processing across platforms

### Initial Tokenization

- Calls `getw` function to extract first token at position 0
- Returns new position and token string
- Token represents component name or command
- `E_O_F` token causes immediate break from processing loop
- `E_O_L` token indicates empty or whitespace-only line

### Load Dispatch

- Calls `Load` function with `ActT`, token, line, position, and line number
- `Load` function looks up component schema and parses fields
- Returns error count for the line
- Accumulated errors added to total for the file
- Processing continues even if individual lines have errors

---

## Utility Functions

Helper functions provide low-level parsing and lookup operations.

### Index Lookup

The `fnd` function searches `ActT.index` map for named component:
- First parameter is `ActT` structure containing the index
- Second parameter `s` is the search key string
- Third parameter `f` is the field name for error messages
- Fourth parameter `chk` controls error reporting behavior
- Returns boolean found flag and integer node identifier

### Check Modes

- `?` check value means return -1 without error if not found
- Matching `f` and `chk` values means return -1 without error
- Other values cause error message to be printed
- Error format shows field name, search key, line number, and check value
- Found entries return true and valid node identifier

### Map Access

- `getName` retrieves value from `map[string]string` by key
- Returns string value if key exists in map
- Returns empty string if key not found
- No error generated for missing keys
- Used for accessing node `Names` map fields

### Word Extraction

`getw` extracts next whitespace-delimited word from line:
- Parameter `line` is the input string
- Parameter `pos` is the starting position in the line
- Returns new position after the word and the word string
- Returns `E_O_L` token if position exceeds line length

### Whitespace Handling

- Skips leading spaces and tabs before extracting word
- Spaces and tabs both treated as delimiters
- Word boundary detected when whitespace encountered
- Returns position pointing to character after the word

### Rest of Line

- `getws` extracts all remaining text from position to end
- Returns length of line as new position
- Returns substring from `pos+1` to end of line
- Returns empty string if position at or beyond end
- Used for `text` type fields that capture entire line remainder

### Colon Words

- `getsw` extracts word that may be followed by colon
- Skips leading whitespace like `getw`
- Stops at space, tab, or colon character
- If colon encountered, advances position by 2 not 1
- Returns word without the colon character
- Used for parsing labels and prefixed identifiers

---

## Extension Mechanisms

The system supports custom extensions through interface implementations.

### KpExtra Structure

- `KpExtra` embeds the `Kp` interface for polymorphism
- Adds `Names map[string]string` for storing key-value pairs
- Provides `GetVar` method for custom variable resolution
- Used in main function to pass command-line arguments to actors

### GetVar Implementation

**Method signature:**
```go
GetVar(glob *GlobT, s []string, ln string) (bool, string)
```

- Parameter `glob` provides access to global state
- Parameter `s` is array of path segments for variable lookup
- Parameter `ln` is line number for error reporting
- Returns boolean success flag and string value

### Custom Variable Lookup

- Checks if `s[0]` exists in `Names` map
- Returns value and true if key found
- Returns formatted error string if key not found
- Error format is `?key?:linenumber`
- Allows actors to access arguments via variable substitution

### Integration with Actors

- `KpExtra` instance passed to `NewAct` and `GoAct` functions
- Actors can reference command-line arguments by index
- Variable `${0}` returns first argument (actor file name)
- Variable `${1}` returns second argument (data file name)
- Higher numbers access additional command-line arguments

---

## Schema Definition

Unit files define the data schema using a component-element model.

### Component Declaration

```
Comp ComponentName parent ParentRef SearchType
```

- Each `Comp` statement declares a node type with a unique name
- The `parent` field establishes hierarchical relationships between components
- `Find` option marks components as top-level searchable nodes
- `FindIn` option marks components as nested within parent contexts
- A `.` value for search type means the component has no name field
- Components can have dot-suffixed flags like `Comp.flag1.flag2` in definition files

### Component Hierarchy

- The parent field creates a tree of component types
- Root components have parent set to `.` indicating no parent
- Child components reference their parent by name
- This hierarchy controls where components can appear in definition files
- The loader validates that child nodes only appear under valid parents
- Each child is stored in both generic `Childs` array and typed `Its` arrays

### Element Fields

```
Element fieldname datatype targetcomp optionality documentation
```

- `Element` statements define the fields within each component
- Each element has a name identifier and a type specification
- Elements appear in definition files in the order declared
- Optional padding elements improve readability without storing data
- Documentation strings describe the purpose of each field

### Component Indexing

- `Find` components are indexed as `CompName_nodename`
- `FindIn` components are indexed as `parentId_CompName_nodename`
- The index maps string keys to numeric node identifiers
- This enables fast lookup during reference resolution
- The `DoAll` command uses indexes to find named nodes

---

## Data Types

Element types control how values are parsed and stored.

### Simple Types

- **word** - Captures a single whitespace-delimited word
- **text** - Captures all remaining text to end of line
- These types store string values directly in the node `Names` map
- Simple types have no validation beyond parsing rules

### Tree Navigation Type

**number** creates tree structures from flat node lists:
- The value indicates nesting depth with 1 for top level
- Higher numbers indicate deeper nesting levels
- Zero value marks nodes outside the tree structure
- Multiple `number` fields enable different tree views of same nodes
- Tree structure is materialized during navigation commands

**Navigation:**
- `Its fieldname.right` navigates to child nodes at next level
- `Its fieldname.left` navigates to parent node at previous level
- `Its fieldname.down` navigates to next sibling at same level
- `Its fieldname.up` navigates to previous sibling at same level
- Navigation commands return empty if no node exists in that direction
- The implementation scans siblings comparing number values

### Parsing Details

- Lines are split on whitespace using `getw` for `word` fields
- The `getws` function captures remaining line for `text` fields
- Tabs and spaces are both treated as delimiters
- No escape sequences or quoting mechanisms are supported
- Empty lines and lines starting with dash are ignored

---

## Reference Types

Reference types create links between nodes enabling graph structures. Each reference element has two fields: name string and namep pointer. The name field stores the target node's name as parsed. The namep field stores the resolved numeric node identifier. Default value for unresolved references is -1.

### Direct References

```
Element fieldname ref TargetComp optionality
Element fieldname link TargetComp optionality
```

- **ref** - Links to top-level Find components by name
- **link** - Links to sibling FindIn components under same parent
- The element value stores the target node's name
- These resolve in the first reference resolution pass

### Derived References

```
Element field1 link TargetComp1 required
Element field2 ref_copy TargetComp2 required
Element field3 ref_child TargetComp3 required
```

- **ref_copy** - Copies a reference ID from a preceding ref/link field
  - The system automatically finds the reference field in the target component
  - Used when you need to access a "grandparent" reference through an intermediate node
  - Example: `Item.customer ref_copy Customer` copies the customer from `Item.order.customer`

- **ref_child** - Looks up a child component within the component referenced by preceding field
  - The system searches children of the referenced component
  - Used to access nested data through a reference
  - Example: After `table ref_copy Type`, use `from_id ref_child Attr` to find an Attr child

- Multiple derived reference fields can chain through multiple hops
- Each derived reference must follow the ref/link it depends on

### Reference Validation

Element optionality controls error handling:
- **required** - Error if target not found
- **optional** - No error if target not found  
- **.** - Error if target not found (when element value is not dot)

The loader reports unresolved references after all resolution passes.

---

## Reference Resolution

References resolve in multiple passes after data loading.

### Resolution Algorithm

- The `refs` function is called repeatedly until no progress
- First pass resolves simple `ref` and `link` references
- Subsequent passes attempt complex `ref_copy` and `ref_child` references
- Each pass returns count of unresolved required references
- Process continues until error count is zero or unchanged
- Typical schemas resolve in two to four passes
- The function returns total error count for validation

### Reference Dependencies

- `ref_child` references depend on their `ref` or `link` parent being resolved first
- `ref_copy` references depend on the source element being resolved
- Multiple `ref_copy` can chain if each depends on previous
- Circular dependencies cause some references to never resolve
- The algorithm detects lack of progress to avoid infinite loops

### Resolution Errors

- Unresolved references show `namep` value of -1
- Not found references show as -2 with error message
- Error format is `?varname?lineA,lineB,component?`
- The optionality field controls whether not found is fatal
- Definition files may need reordering to resolve dependencies
- Drawing dependency graphs helps diagnose resolution issues

### Reverse Navigation

- Forward references enable `Its` navigation to target nodes
- The system automatically creates reverse reference tracking
- Reverse navigation iterates all nodes checking if they reference current node
- `Its CompName_element` navigates from target back to sources
- This is implemented as linear scan not indexed lookup
- Reverse navigation enables bidirectional graph traversal

---

## Definition Files

Definition files contain the actual data following unit schema format.

### File Syntax

- Each line starts with component name followed by field values
- Fields separate by whitespace (typically tabs for alignment)
- The last `text` field extends to end of line capturing all remaining text
- Lines starting with dashes are section separators for readability
- Blank lines and whitespace-only lines are ignored
- Component names can have dot-suffix flags appended

### File Structure

- Top-level Find components can appear anywhere in the file
- FindIn components must appear after their parent component
- Child components continue until another top-level component appears
- Deep nesting is indicated by component type not by indentation
- Good practice groups related nodes together for readability

### Field Values

- `word` fields accept single words without spaces
- `text` fields accept any text including spaces until newline
- Reference fields contain the name of the target node
- `number` fields contain numeric depth indicators
- The `.` value has special meaning often for optional fields
- Padding fields can contain any value for visual alignment

### Loading Process

1. The `Load` function reads component name and looks up schema definition
2. It splits component on dots to extract flags
3. It parses each field according to element type specification
4. Field values store in the node `Names` map
5. Reference fields store target name for later resolution
6. The loader creates parent-child links based on component hierarchy
7. After all files load, reference resolution begins
8. Multiple definition files can be loaded together (comma-separated)

---

## Runtime Data Model

The generated code creates data structures to hold parsed nodes.

### Kp Interface

All component types implement the `Kp` interface:
- `DoIts` method handles navigation and iteration commands
- `GetVar` method handles variable lookups with path traversal
- `GetLineNo` method returns source line number for error reporting
- This enables polymorphic handling of all node types

### Node Structure

Each component type generates a `KpCompName` struct:
- `Me` field stores unique numeric identifier
- `LineNo` field stores source file line number
- `Comp` field stores component name as string
- `Flags` field stores array of dot-suffix flags
- `Names` map stores all simple field values
- `Kparentp` stores numeric parent node identifier
- Each reference element gets `Kelementp` integer pointer field
- Each child component type gets `ItsCompName` array field
- Generic `Childs` array stores mixed child types

### Data Collections

The `ActT` struct stores all component arrays:
- Arrays named `ApCompName` hold all nodes of that type
- The index map provides name-to-id lookups
- Arrays are append-only during loading
- Node identifiers are array indices

---

## Actor Execution

Actors are like functions that process nodes and generate output. The actor is given a node for its use.

### Actor Groups

- Multiple actors with the same name form a group
- The system tries each actor in the group sequentially
- Each actor has a match condition on node fields
- The first actor with matching condition executes
- If no actor matches, the group call fails silently
- This creates a powerful case-switch pattern
- The `Break` command can exit to calling actor

### Match Conditions

```
Actor actorname ComponentName
Actor actorname ComponentName attr = value
Actor actorname ComponentName attr != value
```

- The component field filters which types to process
- The attribute field names the node field to test
- The operator specifies the comparison
- The value field provides the comparison value
- No match condition means the actor always matches
- This serves as a default case at end of group

### Match Operators

- **Equals** (`=`) - Tests exact string match
- **Not-equals** (`!=`) - Tests for difference
- **In** - Tests if value appears in space-separated list
- **Not-in** - Tests if value absent from list
- **Has** - Tests if field list contains value
- **Regex** - Performs regular expression matching

### Combining Conditions

- `&` combines with previous actor using AND logic
- `|` combines with previous actor using OR logic
- `?` prefix makes variables optional without errors
- `??` matches specifically on variable errors
- These enable complex multi-condition matching

### Execution Context

- A calling stack maintains actor invocation chain
- Each stack frame holds the current node and variables
- Variables can access values from previous actors in stack
- The `.` prefix accesses current node fields
- The `.actorname.var` accesses ancestor actor variables
- The `GlobT` structure holds global execution state

---

## Command Types

Commands within actors perform the actual work.

### Iteration Commands

**All** - Calls actor for each component of specified type
- `All CompName actorname` - Iterates all nodes of that type
- `All CompName.value actorname` - Iterates nodes where name equals value

**Its** - Calls actor for nodes related via references
- `Its CompName actorname` - Navigates to typed child components
- `Its element actorname` - Navigates via reference to target node
- `Its CompName_element actorname` - Reverse lookup (nodes referencing current)
- `Its parent actorname` - Navigates to parent node
- Top-level nodes can have a parent element to navigate via reference

**This** - Iterates over collection items calling actor

**Du** - Calls actor with current node for additional match conditions

Loop counters track iteration progress for conditional output.

### Code Generation

**C** - Outputs a line with variable substitution
```
C   public class ${name:c} {
```

**Cs** - Outputs text without newline for inline content
```
Cs   public void method(
```

**Out** - Controls output timing
- `Out delay` - Defers output until first C in calling actors (discarded if none)
- `Out normal` - Resumes normal output (also happens when actor ends)
- `Out off` - Disables output completely
- `Out on` - Enables output

**In** - Redirects output to variable
- `In on` - Enables redirection to `ins` variable
- `In off` - Disables redirection
- `In clear` - Clears the buffer

Generated content flows to file or variable storage.

### Control Flow

**Break** - Exits from actors, loops, or command lists
- `Break actor` - Breaks actor case loop and continues with calling loop/actor
- `Break loop` - Continues after the calling All/Its/This loop
- `Break cmds` - Continues with next actor in same group
- `Break exit` - Terminates entire script immediately
- `Break` can test `IsCheck` flag with True or False options
- The `IsCheck` flag is set in the Add command
- If an actor name is specified, returns to it where it will break as specified

### Data Manipulation

**Add** - Inserts data into collections  
**Var** - Creates variables in current node instance  
**New** - Creates new nodes dynamically during generation  
**Refs** - Re-runs reference resolution after adding nodes  
**Replace** - Performs string substitution on variables

---

## Variable System

Variables use dollar-brace syntax for substitution in strings.

### Variable Syntax

- `${name}` - Substitutes variable value
- `$${` - Produces literal `${` in output
- `${name:c}` - Capitalizes first letter of value
- `${name:u}` - Converts value to uppercase
- `${name:l}` - Converts value to lowercase
- `${name:eol}` - Produces empty string if E_O_L flag set
- `${name:join}` - Joins array with commas
- `${name$}` - Re-evaluates content with nested substitution

### Variable Scope

- `${fieldname}` - Accesses current node's field value from Names map
- `${_.name}` - Accesses collection storage by name
- `${.actorname.var}` - Accesses variable from ancestor in call stack
- `${?name}` - Question prefix suppresses errors for missing variables
- Variables shadow outer scopes when names conflict

### Variable Path Resolution

- Variable names can be dot-separated paths
- The `GetVar` method splits path into string array
- It navigates through nodes following the path
- Each segment can be a field name or navigation command
- Reference fields automatically traverse to target node
- `parent` keyword navigates to parent node
- Paths enable deep property access in single variable

### Special Variables

- `${._arg}` - Argument passed from calling actor
- `${.-}` - Current loop counter starting at zero
- `${.+}` - Loop counter plus one for one-based numbering
- `${._lno}` - Current line number in output file
- `${._key}` - Current item key when iterating collections
- `${._keys}` - List of keys from chained navigation path
- `${kMe}` - Unique numeric index of current node
- `${kComp}` - Component name of current node
- `${._type}` - Collection data type like List or Map
- `${._depth}` - Current actor call stack depth
- `${N}` - Numbered variables hold command-line arguments
- `${.main.N}` - Accesses main actor's Nth argument

These provide context and metadata about execution state.

---

## Collection Storage

Collections provide dynamic storage during generation.

### Collection Types

- **List collections** - Store ordered sequences of values
- **Map collections** - Store key-value pairs
- Collections can store strings, nodes, or structured data
- The system infers type from first Add operation
- Explicit type specification prevents inference errors
- If path starts with `_.`, it's the global collection map
- Otherwise it's the current node (can be a list or map)
- `Add path value` - Path is a dot-separated list

### Add Data Source Operations

- `Add .me` - Stores current node object in collection
- `Add .node` - Stores node from path instead of string value
- `Add .file` - Loads file contents into collection
- `Add .eval` - Evaluates string as expression before storing
- `Add .json` - Parses JSON and adds structured data
- `Add .post` - Performs HTTP POST to URL
- `Add .get` - Performs HTTP GET from URL
- `Add .execute` - Runs database SQL query
- Otherwise, uses the given string value or variable

### Add Create Options

```
Add .map path:key
Add .list path:key
```

After this, the key forms part of the path - no colon unless it is another create.

### Add Data Options

```
Add path value
```

- **Clear** - Empties and recreates collection
- **Break** - Breaks actor loop on duplicate detection
- **Check** - Tests for duplicate without adding, sets flag for Break command
- **No-add** - Only checks without modifying collection

### Collection Access

- `This` command iterates collection calling actor for each item
- `${_.name}` accesses string values
- `${_.name.field}` accesses node fields
- Collections persist across all actors for data accumulation
- Nested collections enable complex data structures

---

## Common Patterns

Several design patterns emerge for common generation tasks.

### Filter Pattern

- Use collections to track processed nodes avoiding duplicates
- Add `check` option tests membership without modifying
- Add `break` option exits actor when duplicate found
- This creates unique sets for filtering repeated data

### Context Accumulation

- Pass data between actors using collections
- Parent actors collect data from child iterations
- Child actors query collections for context information
- This enables cross-references and global analysis

### Multi-Pass Generation

- First pass collects information into collections
- Subsequent passes use collections to generate output
- `Out delay` defers output until next actor
- This enables forward references in output
- The delayed output is cleared if the next actor has no output

### Conditional Output

- Use collections to track state across iterations
- Loop counters enable first-item or last-item detection
- Actor groups with conditions enable case switching
- `?` prefix suppresses errors for optional fields

### Separator Pattern

- Use loop counter `${.-}` to test for first item
- Output comma or separator only when counter is nonzero
- Variable syntax `${.1.,}` generates comma if not first
- This handles comma-separated lists elegantly

---

## Development Workflow

Creating a custom generator follows a structured process.

### Design Phase

- Identify entities and relationships in problem domain
- Sketch data hierarchy and cross-references
- Plan what output format to generate from data
- Consider how actors will traverse data structure

### Schema Development

1. Create unit file defining components and elements
2. Start with simple top-level components
3. Add child components for nested data
4. Define reference elements with appropriate types
5. Use `ref` for top-level links and `link` for sibling links
6. Use `ref_copy` for accessing references through other references
7. Use `ref_child` for looking up children within referenced components

### Schema Testing

1. Create minimal definition file with sample data
2. Run bootstrap generator to create loader
3. Load definition file and check for errors
4. Verify reference resolution completes successfully
5. Check that index map contains expected entries
6. Iterate on schema fixing validation issues

### Actor Development

1. Start with simple actors using C commands only
2. Test navigation commands with debug output
3. Build up complexity incrementally
4. Use collections to track state and prevent duplicates
5. Test with varied input data to verify robustness
6. Add actor groups with conditions for case logic

### Iterative Refinement

1. Add features to schema as needs emerge
2. Regenerate loader after schema changes
3. Extend actors to handle new fields and relationships
4. Refactor actors to reduce duplication
5. Document patterns and conventions for maintainability

---

## Example Applications

The system enables diverse generation tasks.

### Documentation Generator

- Define `Concept`, `Topic`, and `T` components for structured docs
- Use `number` level field for hierarchical topic nesting
- Actors generate HTML with proper heading levels
- Cross-references link related concepts together
- This documentation itself demonstrates the pattern

### Database Schema Generator

- Define `Type`, `Attr`, and `Where` components
- Use `ref` references for foreign key relationships
- Actors generate CREATE TABLE statements
- Additional actors generate ORM class definitions
- View definitions generated from same schema
- Schema documentation generated from same definitions

### Web Application Generator

- Define `Type` for entities with `Attr` for fields
- Generate DAO implementation classes with CRUD methods
- Generate view SQL with joins and decodes
- Generate controller and service layer code
- All from single schema definition

### Loader Generator

- The `g_struct.act` and `g_run.act` actors generate the loader itself
- Takes `gen.unit` and `act.unit` as input schemas
- Generates Go code for parsing and reference resolution
- Creates typed structs for each component
- Implements navigation and variable lookup
- Demonstrates complete self-hosting capability
