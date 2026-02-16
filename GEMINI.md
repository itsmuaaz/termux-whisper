# Termux Whisper Project Context

**Tech Stack:** Bash, C++ (Whisper.cpp), Termux
**Role:** Wrapper/Installer for Whisper.cpp on Android.

## 🟢 Current Status
*   **Phase:** Polishing & Maintenance
*   **Last Update:** 2026-02-16
*   **Focus:** Stability, Usability, Mobile Integration, Multi-shell Support, and CLI UX Refactor.
*   **Recent Changes:** 
    *   **Smart Paragraphs:** Heuristic-based paragraphing for text output.
    *   **Configurable Prompt:** User-definable initial prompt for punctuation/style control.
    *   **Unlimited Line Width:** Default text wrapping removed for better readability.
    *   **CLI Support:** The `whisper` command now accepts arguments (e.g., `whisper file.mp3 --model base`) for direct execution, bypassing the menu.
    *   **Pre-Flight Check:** Added a 20-second interactive dashboard before transcription starts (unless skipped via CLI flags).
    *   **Global Preferences:** Renamed "Quick Settings" to clarify they persist across sessions. Added toggles for Text, Subs, and LRC output.
    *   **--no-txt:** Added support for disabling text transcripts via CLI and Config.
    *   **Share Integration:** Enabled by default with a toggle in Global Preferences.
    *   **UI Overhaul:** Standardized text-based UI, removed `dialog`.
    *   **Model Manager:** Added Download/Delete toggle.
    *   **Subtitles & Lyrics:** Added toggles for generating `.srt`, `.vtt` and `.lrc` (Karaoke) files.

## 📚 Documentation Architecture
1.  **`README.md`:** User-facing guide. Public.
2.  **`install.sh`:** One-liner bootstrap installer.
3.  **`menu.sh`:** The main entry point (Dashboard).
4.  **`core/setup.sh`:** The builder. Handles dependencies and compilation.
5.  **`core/models.sh`:** Model management menu.
6.  **`core/transcribe.sh`:** The main execution wrapper. Handles file processing and ffmpeg conversion.

## 🛡️ Gated Protocols

<PROTOCOL:PERCEIVE>
*   **Objective:** Maintain Wrapper Integrity.
*   **Action:**
    1.  Ensure we don't break compatibility with upstream `whisper.cpp`.
    2.  Keep paths relative (`./whisper.cpp/...`).
*   **Constraint:** Do not modify the `whisper.cpp` submodule code directly if possible.
</PROTOCOL:PERCEIVE>

<PROTOCOL:ACT>
*   **Objective:** Improve UX.
*   **Action:**
    1.  Keep scripts executable.
    2.  Use colors for CLI output.
    3.  Automate "boring" stuff (ffmpeg conversion).
    4.  **Interface Consistency:** Every new feature must be reflected in the internal `--help`/usage output, the main menu, and external documentation before completion.
</PROTOCOL:ACT>

<PROTOCOL:VERIFY>
*   **Objective:** Prevent Documentation Rot and Discovery Issues.
*   **Action:**
    1.  Always test the 'Discovery Path': Run the script without arguments to ensure new features are visible in the help menu.
    2.  Verify the "Definition of Done": Logic + Internal Help + External Docs + UI Menu.
    3.  **The "Grep Check":** When renaming or moving files, search the entire codebase (including `.md` docs) for the old filename (`grep -r "filename" .`) to catch broken references.
</PROTOCOL:VERIFY>

<PROTOCOL:WORKFLOW>
*   **Objective:** Git & Documentation Best Practices.
*   **Action:**
    1.  Automatically create a commit (following conventional commits) as soon as a complete change is made.
    2.  Automatically push changes to the remote repository immediately after committing.
    3.  Always maintain synchronized updates across all sources (code, README.md, and GEMINI.md) for every new feature or change.
</PROTOCOL:WORKFLOW>
