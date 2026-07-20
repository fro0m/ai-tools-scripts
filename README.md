# AI Tools Scripts

Shell scripts for launching AI-powered editors and driving AI-assisted refactoring workflows on Linux.

## Scripts

### `run_windsurf.sh`

Launches the system-installed [Windsurf](https://codeium.com/windsurf) editor with proxy settings applied.

```bash
./run_windsurf.sh
```

The editor is expected at `/usr/share/windsurf/windsurf`. Proxy settings default to `127.0.0.1:2080` and can be overridden with environment variables (see [Proxy Configuration](#proxy-configuration) below).

---

### `run_cursor.sh`

Launches the [Cursor](https://cursor.com) editor from its downloaded AppImage.

```bash
./run_cursor.sh [cursor-options...]
```

- Globs `Cursor-*-x86_64.AppImage` in the **current working directory** and runs the first match — so it must be launched from the directory containing the AppImage.
- Ensures the AppImage is executable (`chmod +x`).
- Runs with `--no-sandbox` for compatibility, and passes any extra arguments through to Cursor.

Example:

```bash
cd ~/apps/cursor
/path/to/run_cursor.sh /path/to/project
```

---

### `clean_up_with_ai.sh`

Runs a batch of predefined code-cleanup/refactoring tasks by spawning each in its own terminal window.

```bash
./clean_up_with_ai.sh
```

**What it does:**
- Defines 11 refactoring tasks (forward declarations, unused-code removal, `const` additions, moving implementations from `.h` to `.cpp`, extracting duplicated code, reordering class members, and more).
- Launches each task in a separate terminal window, detecting `gnome-terminal`, `konsole`, `xfce4-terminal`, or `xterm` in that order.
- Each window invokes `launch-gemini.sh -p "<task>"`.

> ⚠️ **Known limitation:** This script depends on a `launch-gemini.sh` launcher that is **not included** in this directory. To use `clean_up_with_ai.sh`, you must provide your own `launch-gemini.sh` that starts the Gemini CLI with the prompt given via `-p`. The hard-coded target project name inside the prompts (`DesktopStorybook`) will also need adjusting for your own project.

---

## `vscode-downloader/`

Tools for installing and running a portable, self-contained [VS Code](https://code.visualstudio.com) build — useful where a system package is unavailable or a sandboxed/fixed version is needed.

### `install_portable_code.sh`

Downloads the latest stable Linux-x64 VS Code tarball and installs it into a directory of your choice.

```bash
./install_portable_code.sh <install-dir>
```

- `<install-dir>` may be absolute or relative to the script directory.
- Existing user data under `<install-dir>/data` is **preserved** across reinstalls.
- If the bundled `chrome-sandbox` is present, it attempts to `chown root:root` and `chmod 4755` it (via `sudo`). If that fails, it generates a `code-no-sandbox` wrapper that launches VS Code with `--no-sandbox`.

### `run_portable_code.sh`

Launches the portable VS Code installed by `install_portable_code.sh`, detached via `nohup`.

```bash
./run_portable_code.sh <relative-install-dir>
```

- `<relative-install-dir>` must be **relative** to the script directory (it is resolved as `SCRIPT_DIR/<relative-install-dir>`).
- Proxy settings default to `127.0.0.1:2080`; see [Proxy Configuration](#proxy-configuration) below.
- Output is logged to `<install-dir>_output.log`.

---

## Proxy Configuration

`run_windsurf.sh` and `vscode-downloader/run_portable_code.sh` route traffic through a local proxy, defaulting to `127.0.0.1:2080`. Override these via environment variables (e.g. from a local, uncommitted rc file) when your setup differs:

| Variable       | Default       | Description                                      |
|----------------|---------------|--------------------------------------------------|
| `PROXY_HOST`   | `127.0.0.1`   | Proxy host                                       |
| `PROXY_PORT`   | `2080`        | Proxy port                                       |
| `PROXY_BYPASS` | *(unset)*     | Comma-separated list of domains to bypass (optional) |

---

## Requirements

- **Linux** (terminal-based; the editor launchers assume a desktop environment)
- `gnome-terminal`, `konsole`, `xfce4-terminal`, or `xterm` (only required by `clean_up_with_ai.sh`)
- Windsurf installed at `/usr/share/windsurf/windsurf` (for `run_windsurf.sh`)
- A Cursor AppImage in the working directory (for `run_cursor.sh`)
- `curl` and `tar` (for `vscode-downloader/install_portable_code.sh`)
