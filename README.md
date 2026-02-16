# Termux Whisper 🗣️
**Private, Offline Audio Transcription for Android**

A lightweight wrapper for [whisper.cpp](https://github.com/ggerganov/whisper.cpp) to transcribe audio files locally on Android via Termux. No internet required.

## 🚀 Quick Start

### 1. Install & Setup (One-Liner)
Open Termux and paste this command:
```bash
curl -sL https://raw.githubusercontent.com/itsmuaaz/termux-whisper/main/install.sh | bash
```
This will install all dependencies, fetch the engine, and compile it automatically.

---

### 2. Manual Installation (Alternative)
If you prefer to do it step-by-step:
```bash
pkg install git -y
git clone https://github.com/itsmuaaz/termux-whisper.git
cd termux-whisper
chmod +x core/*.sh menu.sh
./core/setup.sh
```

### 3. Usage
**Interactive Dashboard:**
Restart Termux, then simply type:
```bash
whisper
```

**CLI Commands:**
You can also use the `whisper` command directly with arguments:

| Goal | Command |
| :--- | :--- |
| **Transcribe File** | `whisper video.mp4` |
| **Specify Model** | `whisper voice.m4a --model base` |
| **Generate Subtitles** | `whisper movie.mkv --subs` |
| **Generate Lyrics** | `whisper song.mp3 --lrc` |
| **Disable Text Output** | `whisper video.mp4 --no-txt` |
| **Disable Paragraphs** | `whisper video.mp4 --no-paragraphs` |
| **Batch Process** | `whisper /path/to/folder/` |
| **Direct File Picker** | `whisper --file-picker` |

*Available Models:* `tiny`, `base`, `small`, `medium`, `large-v3-turbo`

### 4. Interactive Pre-Flight
When you run Whisper (via menu or Share), you will see a **20-second "Pre-Flight" dashboard**.
- Shows your current target, model, and output settings.
- Allows you to toggle Subtitles/Lyrics or change the model **for this run only**.
- Press **Enter** to start immediately.
- **Note:** Using specific CLI flags (e.g., `--subs`) skips this check for faster automation.

## ✨ Features
- **One-Click Dashboard:** A professional TUI menu to access all features.
- **Share to Transcribe:** Automatically enabled. Share audio files from WhatsApp or File Manager directly to Termux.
- **Privacy:** 100% offline; data stays on your device.
- **Smart:** Auto-detects audio formats (including OPUS/OGG) and checks for audio streams.
- **Native Picker:** Visual file picker via Android System (`--file-picker`).
- **Live Progress:** Real-time feedback showing transcription segments and timestamps.
- **Smart Paragraphs:** Automatically structures text into paragraphs for better readability.
- **Convenient:** Prompts to open the transcript immediately after processing.
- **Batch:** Transcribe single files or entire directories.
- **Subtitles:** Optionally generate `.srt` and `.vtt` files.
- **Lyrics:** Generate `.lrc` files for synced music lyrics.
- **Formats:** Supports MP3, WAV, M4A, OPUS, OGG, FLAC, MP4, MKV, AVI, MOV.

## ⚠️ Notes
*   **Transcripts:** Saved to `/sdcard/Download/Termux-Whisper/` when using the picker, or next to the file if run manually.

## 🌟 See Also
Check out [**Termux Bootstrap**](https://github.com/itsmuaaz/termux-bootstrap) – A modular, safe, and mobile-optimized script to transform Termux into a powerful development environment. It includes this project as a community extra!

---
*Powered by [whisper.cpp](https://github.com/ggerganov/whisper.cpp)*