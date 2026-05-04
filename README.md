# Compilers-Final-Project
 Minishell — A Bash-Based Shell Interpreter


## Table of Contents
1. [Project Overview](#project-overview)
2. [Group Members](#group-members)
3. [Compiler Phases](#compiler-phases)
   - [Lexical Analysis](#1-lexical-analysis)
   - [Syntax Analysis](#2-syntax-analysis)
   - [Semantic Analysis](#3-semantic-analysis)
4. [Project Structure](#project-structure)
5. [Features](#features)
6. [How to Build & Run](#how-to-build--run)
7. [Examples](#examples)



## Project Overview

Minishell is a simplified Unix shell interpreter modeled after **Bash**. It reads user input from the command line, processes it through the three classical compiler phases (lexical, syntax, and semantic analysis), and executes the resulting commands using system calls.

The project demonstrates all core compiler design principles applied to a real, interactive language processor — the shell command language.

**Model:** Bash-Based Shell Interpreter (Pipeline-Based)  
**Language:** C  
**Platform:** Linux (Ubuntu)



## Made By
Nour Fakih 202402779


## Compiler Phases

### 1. Lexical Analysis

**Location:** `Lexical_Analysis/`

The lexical phase reads the raw input string and breaks it down into a stream of **tokens**. Each token has a type and an associated string value.

**Token types produced:**
| Token | Description |
|-------|-------------|
| `WORD` | A command name or argument |
| `PIPE` | The `\|` operator |
| `IN` | Input redirection `<` |
| `OUT` | Output redirection `>` |
| `APPEND` | Append redirection `>>` |
| `HEREDOC` | Here-document `<<` |
| `EMPTY` | Empty quoted string (`''` or `""`) |
| `T_EOF` | End of input |

**Responsibilities:**
- Splitting the input string into tokens using `splits.c` and `chars.c`
- Handling single-quoted (`'`) and double-quoted (`"`) strings
- Detecting `$` for variable expansion (flagged on the token)
- Reporting unclosed quote errors (e.g., `echo "hello` → *syntax error near unclosed quote*)
- Tracking spacing between tokens (used later during expansion joining)

**Example:**
```
Input:  echo "hello world" | cat > out.txt
Tokens: [WORD:"echo"] [WORD:"hello world"(quoted)] [PIPE] [WORD:"cat"] [OUT] [WORD:"out.txt"]
```

---

### 2. Syntax Analysis

**Location:** `Syntax_Analysis/`

The syntax phase validates that the token sequence follows the **grammar rules** of the shell language, then organizes tokens into a linked list of `t_cmd` command structures.

**Responsibilities:**
- Validating token order via `check_tkns()` — no two consecutive operators, no trailing pipe or redirect at end of input
- Building `t_cmd` structs: each command holds its name, argument array, redirection list, file descriptors, and PID
- Splitting the pipeline into individual commands at each `PIPE` token
- Attaching redirection tokens (`IN`, `OUT`, `APPEND`, `HEREDOC`) to their corresponding commands

**Grammar rules enforced (examples):**
- `| |` → error: *unexpected token `|`*
- `echo >` → error: *unexpected token `newline`*
- `< |` → error: *unexpected token `|`*
- A command starting with a `PIPE` is rejected immediately

**Data structure produced:**
```
t_cmd (echo) → args["echo","hello"] → redir: none → next →
t_cmd (cat)  → args["cat"]          → redir: OUT("out.txt") → next → NULL
```

---

### 3. Semantic Analysis

**Location:** `Semantic_Analysis/`

The semantic phase checks the **meaning** of the parsed commands — are the variables, paths, and commands actually valid and executable? This phase also performs variable expansion before execution.

**Sub-phases:**

**a) Variable Expansion** (`expansion/`)
- Replaces `$VAR` with its value from the environment list
- `$?` expands to the exit status of the last command
- Single-quoted strings are never expanded
- Double-quoted strings expand `$VAR` but protect spaces

**b) Path Resolution & Command Validation** (`Rest/exec/`)
- Searches `$PATH` directories to locate external commands
- Checks file existence and execute permissions
- Returns appropriate error codes:
  - `127` — command not found
  - `126` — permission denied
  - `1` — general error

**c) Builtin Recognition** (`Rest/builtins/`)
- Identifies and dispatches the 7 built-in commands before any `execve` call:
  `echo`, `cd`, `pwd`, `export`, `unset`, `env`, `exit`

**d) Environment Management** (`Rest/env/`)
- Maintains a linked-list environment (`t_env`) mirroring `envp`
- `export` adds/updates variables; `unset` removes them
- `SHLVL` is tracked and incremented/decremented on shell entry/exit

**Semantic errors detected (examples):**
```
$ ./script.sh        # file exists but no execute bit → "Permission denied" (exit 126)
$ unknowncmd         # not in PATH → "command not found" (exit 127)
$ cd /nonexistent    # directory doesn't exist → "No such file or directory"
$ export 1BAD=val    # invalid identifier → rejected silently
```

## Features

- Interactive prompt with command history (via `readline`)
- Full pipeline support: `cmd1 | cmd2 | cmd3`
- All four redirections: `<`, `>`, `>>`, `<<` (heredoc)
- Environment variable expansion: `$VAR`, `$?`
- Single and double quote handling
- Signal handling: `Ctrl-C` (new prompt), `Ctrl-D` (exit), `Ctrl-\` (ignored)
- 7 built-in commands: `echo -n`, `cd`, `pwd`, `export`, `unset`, `env`, `exit`
- Proper exit status propagation throughout pipelines



## How to Build & Run

```bash
# Clone the repository
git clone <repo-url>
cd Minishell

# Build
make

# Run
./minishell
```

**Dependencies:** `gcc`, `make`, `libreadline-dev`

## Examples

```bash
# Basic command
minishell$ echo "Hello, World!"
Hello, World!

# Pipeline
minishell$ ls -la | grep ".c" | wc -l
42

# Redirections
minishell$ cat < input.txt > output.txt
minishell$ echo "log entry" >> log.txt

# Heredoc
minishell$ cat << EOF
> Hello $USER
> EOF
Hello student

# Variable expansion
minishell$ export GREETING="Hello"
minishell$ echo $GREETING $USER
Hello student

# Exit status
minishell$ ls nonexistent
ls: cannot access 'nonexistent': No such file or directory
minishell$ echo $?
2
```


## Compilation Pipeline Diagram

```
User Input String
        │
        ▼
┌───────────────────┐
│  Lexical Analysis │  → Token linked list (WORD, PIPE, IN, OUT, ...)
│  (Tokenizer)      │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  Syntax Analysis  │  → Validated t_cmd linked list (commands + redirections)
│  (Parser)         │
└───────────────────┘
        │
        ▼
┌───────────────────┐
│ Semantic Analysis │  → Expanded args, resolved paths, builtin detection
│ (Expansion+Exec)  │
└───────────────────┘
        │
        ▼
   fork() / execve()  →  Output to terminal
```