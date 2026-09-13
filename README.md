# Neovim Config

LazyVim-based Neovim configuration with LSP, debugging, and formatting for **Python**, **Go**, and **C#**.

## Table of Contents

- [Prerequisites](#prerequisites)
- [First-Time Setup](#first-time-setup)
- [Navigation](#navigation)
- [Editing](#editing)
- [Running Code](#running-code)
- [Debugging](#debugging)
- [LSP Features](#lsp-features)
- [Config Structure](#config-structure)

---

## Prerequisites

Make sure these are installed on your system:

| Tool | Install |
|---|---|
| **Neovim** ≥ 0.10 | `sudo apt install neovim` or [build from source](https://github.com/neovim/neovim) |
| **Git** | `sudo apt install git` |
| **Node.js** | Required by some LSP servers |
| **Python 3** | `sudo apt install python3 python3-venv` |
| **Go** | [golang.org/dl](https://golang.org/dl/) |
| **.NET SDK** | [dotnet.microsoft.com](https://dotnet.microsoft.com/download) (for C#) |
| **ripgrep** | `sudo apt install ripgrep` (for Telescope search) |
| **fd** | `sudo apt install fd-find` (for Telescope file finder) |

## First-Time Setup

```bash
# Open Neovim — plugins install automatically on first launch
nvim

# Inside Neovim, sync all plugins:
:Lazy sync

# Verify LSP servers and tools are installed:
:Mason
```

Mason auto-installs: `gopls`, `pyright`, `omnisharp`, `debugpy`, `delve`, `netcoredbg`, `gofumpt`, `goimports`, `black`, `isort`, `prettier`, `stylua`, `csharpier`, and more.

---

## Navigation

### File Navigation

| Key | Action |
|---|---|
| `<leader>ff` | **Find files** (Telescope fuzzy finder) |
| `<leader>fg` | **Live grep** (search text across project) |
| `<leader>fb` | **Find buffers** (switch open files) |
| `<leader>fr` | **Recent files** |
| `<leader>e` | **Toggle file tree** (Neo-tree sidebar) |
| `<leader><leader>` | **Find files** (root dir) |

> `<leader>` is **Space** by default in LazyVim.

### Searching

#### Find Files by Name (`<leader>ff`)

Opens Telescope fuzzy file finder. Type part of the filename to narrow results.

| Trick | Example | What it does |
|---|---|---|
| Fuzzy match | `mainpy` | Matches `main.py`, `main_app.py`, etc. |
| Path segments | `src main` | Files with `main` inside a `src` directory |
| Exact match | `'main.py` | Prefix with `'` for exact substring match |
| Extension filter | `.go` | Shows only `.go` files |

**Inside the Telescope picker:**

| Key | Action |
|---|---|
| `Ctrl-j` / `Ctrl-k` | Move down / up in results |
| `Ctrl-n` / `Ctrl-p` | Move down / up in results (alternative) |
| `Enter` | Open selected file |
| `Ctrl-x` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `Ctrl-t` | Open in new tab |
| `Esc` | Close picker (normal mode) |
| `Ctrl-c` | Close picker (insert mode) |

#### Search Text Across Project (`<leader>fg`)

Opens **live grep** — searches file contents in real time as you type.

| Trick | Example | What it does |
|---|---|---|
| Simple search | `func main` | Finds all occurrences of "func main" |
| Filter by glob | `func main  --  *.go` | Search only in `.go` files (type `  --  ` then the glob) |
| Regex | `func \w+Handler` | Use regex patterns for complex matches |

> **Tip:** After searching, press `Ctrl-q` to send all results to the **quickfix list**, then navigate with `]q` / `[q`.

#### Search Current Word

| Key | Action |
|---|---|
| `<leader>sw` | **Search word** under cursor across project |
| `<leader>sW` | **Search WORD** under cursor (includes special chars) |
| `*` | Search word under cursor in current file (forward) |
| `#` | Search word under cursor in current file (backward) |

#### Search by Symbol

| Key | Action |
|---|---|
| `<leader>ss` | **Search symbols** in current buffer (functions, classes, etc.) |
| `<leader>sS` | **Search symbols** across the whole workspace |

#### Search in Neo-tree (`<leader>e`)

While the file tree is focused:

| Key | Action |
|---|---|
| `/` | **Filter** files by name (fuzzy) |
| `f` | **Filter** files by name |
| `H` | Toggle **hidden files** (dotfiles) |
| `Ctrl-c` | Clear filter |

#### Other Search Commands

| Key | Action |
|---|---|
| `<leader>s"` | Search **registers** |
| `<leader>sa` | **Auto commands** |
| `<leader>sc` | **Command history** |
| `<leader>sC` | **Available commands** |
| `<leader>sd` | **Diagnostics** (current buffer) |
| `<leader>sD` | **Diagnostics** (all buffers) |
| `<leader>sh` | **Help tags** |
| `<leader>sk` | **Keymaps** (search what any key does) |
| `<leader>sm` | **Marks** |
| `<leader>sR` | **Resume** last search |

### Moving Around a File

| Key | Action |
|---|---|
| `gg` | Go to top of file |
| `G` | Go to bottom of file |
| `Ctrl-d` | Page down (half screen) |
| `Ctrl-u` | Page up (half screen) |
| `{` / `}` | Jump to previous / next blank line |
| `w` / `b` | Jump forward / backward by word |
| `f{char}` | Jump forward to `{char}` on current line |
| `%` | Jump to matching bracket |
| `:{number}` | Go to line number |

### Code Navigation (LSP)

| Key | Action |
|---|---|
| `gd` | **Go to definition** |
| `gr` | **Go to references** |
| `gI` | **Go to implementation** |
| `gy` | **Go to type definition** |
| `K` | **Hover documentation** (press K on any symbol) |
| `Ctrl-o` | **Jump back** (after go-to-definition) |
| `Ctrl-i` | **Jump forward** |

#### Exploring Functions & Docs (e.g. Go)

1. Place your cursor on any function name (e.g. `http.ListenAndServe`)
2. Press **`K`** — a floating window shows the function signature + doc comment
3. Press **`K`** again to **enter** the floating window (scroll with `j`/`k`, close with `q`)
4. Want to see the source? Press **`gd`** instead — jumps straight to the definition
5. Press **`Ctrl-o`** to jump back to where you were

> **Tip:** `K` works on any symbol — functions, types, struct fields, packages, variables. In Go it pulls from `gopls` so you get the same docs as `go doc`. In Python it shows the docstring from `pyright`.

### Window Management

| Key | Action |
|---|---|
| `<leader>-` | Split window horizontally |
| `<leader>\|` | Split window vertically |
| `Ctrl-h/j/k/l` | Move between splits |
| `<leader>wd` | Close current window |

### Buffers (Open Files)

| Key | Action |
|---|---|
| `<S-h>` | Previous buffer (Shift+h) |
| `<S-l>` | Next buffer (Shift+l) |
| `<leader>bd` | Close current buffer |
| `<leader>bo` | Close all other buffers |

---

## Editing

### Basic Editing

| Key | Action |
|---|---|
| `i` | Insert mode (before cursor) |
| `a` | Insert mode (after cursor) |
| `o` / `O` | New line below / above |
| `dd` | Delete line |
| `yy` | Copy (yank) line |
| `p` | Paste below |
| `u` | Undo |
| `Ctrl-r` | Redo |
| `.` | Repeat last action |
| `Esc` | Back to Normal mode |

### Selection & Multi-edit

| Key | Action |
|---|---|
| `v` | Visual mode (select characters) |
| `V` | Visual line mode (select lines) |
| `Ctrl-v` | Visual block mode (column select) |
| `>` / `<` | Indent / unindent selection |
| `gc` | Toggle comment (visual mode) |
| `gcc` | Toggle comment (current line) |

### Search & Replace

| Key | Action |
|---|---|
| `/pattern` | Search forward |
| `?pattern` | Search backward |
| `n` / `N` | Next / previous match |
| `<leader>sr` | **Search and replace** (Spectre) |
| `:%s/old/new/g` | Replace all in file |

### Formatting

| Key | Action |
|---|---|
| `<leader>cf` | **Format file** (runs language formatter) |

Formatters per language (auto-configured):

| Language | Formatter |
|---|---|
| Python | `isort` → `black` |
| Go | `goimports` → `gofumpt` |
| C# | `csharpier` |

---

## Running Code

### Option 1: Floating Terminal (Simplest)

Press **`Ctrl-/`** to toggle a floating terminal, then run:

```bash
# Python
python3 main.py
python3 -m pytest                 # run tests

# Go
go run .                          # run package
go run main.go                    # run single file
go test ./...                     # run all tests

# C#
dotnet run                        # run project
dotnet test                       # run tests
```

Press **`Ctrl-/`** again to hide the terminal (it stays alive — press Up to re-run).

### Option 2: Quick Run from Command Mode

Press `:` and type:

```vim
:!python3 %                      " run current Python file
:!go run %                        " run current Go file
:!dotnet run                      " run C# project
```

`%` expands to the current filename.

### Option 3: Run in a Split

```vim
:split | terminal python3 %       " Python in bottom split
:split | terminal go run %         " Go in bottom split
:split | terminal dotnet run       " C# in bottom split
```

Output stays visible. Press `i` to interact, `Ctrl-\` `Ctrl-n` to exit terminal mode.

---

## Debugging

Debugging uses DAP (Debug Adapter Protocol) with a full graphical UI.

### Debug Adapters

| Language | Adapter | Installed via |
|---|---|---|
| Python | `debugpy` | Mason |
| Go | `delve` | Mason |
| C# | `netcoredbg` | Mason |

### Quick Start

```
1.  Open a file (e.g. main.go or app.py)
2.  Set breakpoint       →  <leader>db    (red dot appears in gutter)
3.  Start debugging      →  <leader>dc    (pick a launch config)
4.  Code pauses          →  inspect variables in the DAP UI panels
5.  Step through code    →  <leader>ds    (step over)
6.  Stop                 →  <leader>dt
```

### Debugger Keybindings

| Key | Action |
|---|---|
| `<leader>db` | **Toggle breakpoint** |
| `<leader>dB` | Breakpoint with condition |
| `<leader>dc` | **Continue / Start** |
| `<leader>ds` | **Step over** (next line) |
| `<leader>di` | **Step into** (enter function) |
| `<leader>do` | **Step out** (exit function) |
| `<leader>dt` | **Terminate** session |
| `<leader>du` | Toggle DAP UI panels |
| `<leader>de` | Evaluate expression under cursor |

### Launch Configs

When you press `<leader>dc`, you'll be prompted to choose:

**Python:**
- `Launch file` — runs current `.py` file (auto-detects virtualenv)

**Go:**
- `Launch file` — runs current `.go` file
- `Launch package` — runs the package (like `go run .`)
- `Debug test` — debugs the current test file

**C#:**
- `Launch` — prompts for the path to the built `.dll`

### DAP UI Panels

When debugging, panels open automatically showing:

| Panel | What it shows |
|---|---|
| **Scopes** | Local and global variables with current values |
| **Breakpoints** | All breakpoints with file and line |
| **Stacks** | Call stack and goroutines (Go) / threads |
| **Watches** | Custom expressions you add |
| **Console** | Program output and debug console |

---

## LSP Features

These work automatically in any Python, Go, or C# file:

| Feature | How to use |
|---|---|
| **Auto-complete** | Just start typing — suggestions appear automatically |
| **Signature help** | Type `(` after a function — parameter info shows |
| **Diagnostics** | Errors/warnings show inline as you type |
| `<leader>ca` | **Code actions** (quick fixes, refactors) |
| `<leader>cr` | **Rename symbol** (across all files) |
| `<leader>cd` | **Line diagnostics** (show full error message) |
| `]d` / `[d` | Jump to next / previous diagnostic |

### Completion Keybindings

| Key | Action |
|---|---|
| `Ctrl-Space` | Manually trigger completion |
| `Ctrl-n` / `Ctrl-p` | Next / previous item |
| `Enter` | Confirm selection |
| `Ctrl-e` | Dismiss menu |
| `Tab` / `Shift-Tab` | Jump in snippets |

---

## Config Structure

```
~/.config/nvim/
├── init.lua                          # Entry point
├── lazyvim.json                      # LazyVim extras (neo-tree, dap)
├── lua/
│   ├── config/
│   │   ├── lazy.lua                  # Plugin manager bootstrap
│   │   ├── options.lua               # Editor options
│   │   ├── keymaps.lua               # Custom keymaps
│   │   ├── autocmds.lua              # Auto commands
│   │   └── remote_clipboard.lua      # OSC 52 clipboard (SSH/tmux)
│   └── plugins/
│       ├── theme.lua                 # Active colorscheme (retro-82)
│       ├── all-themes.lua            # Available themes
│       ├── omarchy-theme-hotreload.lua
│       ├── disable-news-alert.lua
│       ├── snacks-animated-scrolling-off.lua
│       ├── example.lua               # LazyVim examples (inactive)
│       └── lsp/
│           ├── masion.lua            # Mason base config
│           ├── go.lua                # Go: gopls + formatting
│           ├── python.lua            # Python: pyright + formatting
│           ├── csharp.lua            # C#: omnisharp + formatting
│           └── debugging.lua         # DAP configs for all languages
└── plugin/after/
    └── transparency.lua              # Transparent background
```

### Useful Commands

| Command | What it does |
|---|---|
| `:Lazy` | Plugin manager UI |
| `:Lazy sync` | Install/update all plugins |
| `:Mason` | LSP/tool installer UI |
| `:LspInfo` | Show active LSP servers |
| `:checkhealth` | Diagnose issues |
| `:LazyExtras` | Browse available LazyVim extras |
