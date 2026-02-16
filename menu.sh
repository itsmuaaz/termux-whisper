#!/bin/bash

# Termux Whisper Unified Dashboard
# Text-based CLI for easy access to all features.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRANS_SCRIPT="${SCRIPT_DIR}/core/transcribe.sh"
MODELS_SCRIPT="${SCRIPT_DIR}/core/models.sh"
CONFIG_FILE="$HOME/.termux_whisper_config"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Load Config
if [ ! -f "$CONFIG_FILE" ]; then
    echo "DEFAULT_LANG=auto" > "$CONFIG_FILE"
fi
# Ensure defaults exist
if ! grep -q "INITIAL_PROMPT=" "$CONFIG_FILE"; then
    echo "INITIAL_PROMPT=\"Hello! Welcome to this transcription. I will speak clearly, use proper punctuation, and capitalize sentences correctly.\"" >> "$CONFIG_FILE"
fi
if ! grep -q "MAX_LINE_LEN=" "$CONFIG_FILE"; then
    echo "MAX_LINE_LEN=0" >> "$CONFIG_FILE"
fi
if ! grep -q "SMART_PARAGRAPHS=" "$CONFIG_FILE"; then
    echo "SMART_PARAGRAPHS=true" >> "$CONFIG_FILE"
fi
source "$CONFIG_FILE"

# DIRECT EXECUTION MODE
# If arguments are provided (e.g. "whisper file.mp3"), bypass the menu
if [ $# -gt 0 ]; then
    bash "$TRANS_SCRIPT" "$@"
    exit $?
fi

print_header() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Termux Whisper Dashboard         ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo -e "${GREEN}Tip: Share audio from any app to 'Termux' to transcribe!${NC}"
}

print_menu() {
    echo -e "\n${YELLOW}Choose an action:${NC}"
    echo -e "  ${GREEN}1)${NC} Transcribe File (System Picker)"
    echo -e "  ${GREEN}2)${NC} Manage Models"
    echo -e "  ${GREEN}3)${NC} Global Preferences"
    echo -e "  ${GREEN}4)${NC} Help / About"
    echo -e "  ${RED}q)${NC} Exit"
    echo ""
}

set_language() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Set Default Language             ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo "Current: ${DEFAULT_LANG}"
    echo "Enter language code (e.g., 'en', 'es', 'fr', 'auto'):"
    read -p "> " lang_input

    if [ -n "$lang_input" ]; then
        if grep -q "DEFAULT_LANG=" "$CONFIG_FILE"; then
            sed -i "s/DEFAULT_LANG=.*/DEFAULT_LANG=$lang_input/" "$CONFIG_FILE"
        else
            echo "DEFAULT_LANG=$lang_input" >> "$CONFIG_FILE"
        fi
        DEFAULT_LANG="$lang_input"
        echo -e "${GREEN}Language set to: $lang_input${NC}"
    else
        echo -e "${YELLOW}Cancelled.${NC}"
    fi
    read -p "Press Enter to return..." dummy
}

toggle_txt() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Generate Text Transcript         ${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    # Toggle logic (Defaults to true if missing)
    if [ "$GENERATE_TXT" = "false" ]; then
        NEW_VAL="true"
        echo -e "${GREEN}Text Transcript Enabled.${NC}"
    else
        NEW_VAL="false"
        echo -e "${YELLOW}Text Transcript Disabled.${NC}"
    fi

    # Update Config
    if grep -q "GENERATE_TXT=" "$CONFIG_FILE"; then
        sed -i "s/GENERATE_TXT=.*/GENERATE_TXT=$NEW_VAL/" "$CONFIG_FILE"
    else
        echo "GENERATE_TXT=$NEW_VAL" >> "$CONFIG_FILE"
    fi
    
    read -p "Press Enter to return..." dummy
}

toggle_subs() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Generate Subtitles               ${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    # Toggle logic
    if [ "$GENERATE_SUBS" = "true" ]; then
        NEW_VAL="false"
        echo -e "${YELLOW}Subtitles Disabled.${NC}"
    else
        NEW_VAL="true"
        echo -e "${GREEN}Subtitles Enabled (.srt & .vtt).${NC}"
    fi

    # Update Config
    if grep -q "GENERATE_SUBS=" "$CONFIG_FILE"; then
        sed -i "s/GENERATE_SUBS=.*/GENERATE_SUBS=$NEW_VAL/" "$CONFIG_FILE"
    else
        echo "GENERATE_SUBS=$NEW_VAL" >> "$CONFIG_FILE"
    fi
    
    read -p "Press Enter to return..." dummy
}

toggle_lrc() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Generate LRC (Karaoke)           ${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    # Toggle logic
    if [ "$GENERATE_LRC" = "true" ]; then
        NEW_VAL="false"
        echo -e "${YELLOW}LRC Generation Disabled.${NC}"
    else
        NEW_VAL="true"
        echo -e "${GREEN}LRC Generation Enabled.${NC}"
    fi

    # Update Config
    if grep -q "GENERATE_LRC=" "$CONFIG_FILE"; then
        sed -i "s/GENERATE_LRC=.*/GENERATE_LRC=$NEW_VAL/" "$CONFIG_FILE"
    else
        echo "GENERATE_LRC=$NEW_VAL" >> "$CONFIG_FILE"
    fi
    
    read -p "Press Enter to return..." dummy
}

toggle_paragraphs() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Smart Paragraphs                 ${NC}"
    echo -e "${BLUE}========================================${NC}"
    
    # Toggle logic
    if [ "$SMART_PARAGRAPHS" = "true" ]; then
        NEW_VAL="false"
        echo -e "${YELLOW}Smart Paragraphs Disabled.${NC}"
    else
        NEW_VAL="true"
        echo -e "${GREEN}Smart Paragraphs Enabled.${NC}"
    fi

    # Update Config
    if grep -q "SMART_PARAGRAPHS=" "$CONFIG_FILE"; then
        sed -i "s/SMART_PARAGRAPHS=.*/SMART_PARAGRAPHS=$NEW_VAL/" "$CONFIG_FILE"
    else
        echo "SMART_PARAGRAPHS=$NEW_VAL" >> "$CONFIG_FILE"
    fi
    
    read -p "Press Enter to return..." dummy
}

toggle_share() {
    local TERMUX_BIN="$HOME/bin"
    local HOOK_FILE="$TERMUX_BIN/termux-file-editor"
    local DISABLED_HOOK="$TERMUX_BIN/termux-file-editor.disabled"

    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}    Android Share Integration           ${NC}"
    echo -e "${BLUE}========================================${NC}"

    # Check current status
    if [ -f "$HOOK_FILE" ] && grep -q "Termux Whisper" "$HOOK_FILE"; then
        # Currently Enabled -> Disable
        mv "$HOOK_FILE" "$DISABLED_HOOK"
        echo -e "${YELLOW}Integration Disabled.${NC}"
        echo "The 'Share to Termux' feature is now turned off."
    elif [ -f "$DISABLED_HOOK" ] && grep -q "Termux Whisper" "$DISABLED_HOOK"; then
        # Currently Disabled -> Enable
        mv "$DISABLED_HOOK" "$HOOK_FILE"
        chmod +x "$HOOK_FILE"
        echo -e "${GREEN}Integration Enabled.${NC}"
        echo "You can now share files to Termux again."
    else
        # Missing -> Create
        echo "Hook file missing. Recreating..."
        mkdir -p "$TERMUX_BIN"
        cat << EOF > "$HOOK_FILE"
#!/bin/bash
# Termux Whisper Hook
# Generated by menu.sh

INPUT_FILE="\$1"

if [ -z "\$INPUT_FILE" ]; then
    echo "Error: No file received."
    read -p "Press Enter to exit..."
    exit 1
fi

# Launch Termux Whisper
bash "${TRANS_SCRIPT}" "\$INPUT_FILE"

echo ""
read -p "Process complete. Press Enter to close..."
EOF
        chmod +x "$HOOK_FILE"
        echo -e "${GREEN}Integration Created & Enabled.${NC}"
    fi
    read -p "Press Enter to return..." dummy
}

edit_prompt() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}       Edit Initial Prompt              ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo "Current Prompt:"
    echo -e "${YELLOW}$INITIAL_PROMPT${NC}"
    echo ""
    echo "Enter new prompt (leave empty to keep current):"
    read -p "> " new_prompt

    if [ -n "$new_prompt" ]; then
        # Escape potential slashes for sed
        safe_prompt=$(echo "$new_prompt" | sed 's/[\/&]/\\&/g')
        
        if grep -q "INITIAL_PROMPT=" "$CONFIG_FILE"; then
            sed -i "s/INITIAL_PROMPT=.*/INITIAL_PROMPT=\"$safe_prompt\"/" "$CONFIG_FILE"
        else
            echo "INITIAL_PROMPT=\"$new_prompt\"" >> "$CONFIG_FILE"
        fi
        INITIAL_PROMPT="$new_prompt"
        echo -e "${GREEN}Prompt updated.${NC}"
    else
        echo -e "${YELLOW}No change made.${NC}"
    fi
    read -p "Press Enter to return..." dummy
}

settings_menu() {
    local TERMUX_BIN="$HOME/bin"
    local HOOK_FILE="$TERMUX_BIN/termux-file-editor"

    while true; do
        source "$CONFIG_FILE"
        
        # Check Share Status
        local SHARE_STATUS="${RED}Disabled${NC}"
        if [ -f "$HOOK_FILE" ] && grep -q "Termux Whisper" "$HOOK_FILE"; then
            SHARE_STATUS="${GREEN}Enabled${NC}"
        fi

        # Check Output Statuses
        local TXT_STATUS="${GREEN}Enabled${NC}"
        if [ "$GENERATE_TXT" = "false" ]; then TXT_STATUS="${RED}Disabled${NC}"; fi

        local SUBS_STATUS="${RED}Disabled${NC}"
        if [ "$GENERATE_SUBS" = "true" ]; then SUBS_STATUS="${GREEN}Enabled${NC}"; fi

        local LRC_STATUS="${RED}Disabled${NC}"
        if [ "$GENERATE_LRC" = "true" ]; then LRC_STATUS="${GREEN}Enabled${NC}"; fi

        local PARA_STATUS="${RED}Disabled${NC}"
        if [ "$SMART_PARAGRAPHS" = "true" ]; then PARA_STATUS="${GREEN}Enabled${NC}"; fi

        clear
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}         Global Preferences             ${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo -e "  1) Set Default Language [Current: ${DEFAULT_LANG}]"
        echo -e "  2) Generate Text Transcript [$TXT_STATUS]"
        echo -e "  3) Generate Subtitles [$SUBS_STATUS]"
        echo -e "  4) Generate LRC (Karaoke) [$LRC_STATUS]"
        echo -e "  5) Smart Paragraphs [$PARA_STATUS]"
        echo -e "  6) Android Share Integration [$SHARE_STATUS]"
        echo -e "  7) Edit Initial Prompt"
        echo -e "  8) View Config File"
        echo -e "  b) Back"
        echo ""
        read -p "Select: " opt
        case $opt in
            1) set_language ;;
            2) toggle_txt ;;
            3) toggle_subs ;;
            4) toggle_lrc ;;
            5) toggle_paragraphs ;;
            6) toggle_share ;;
            7) edit_prompt ;;
            8) 
                clear
                echo -e "${BLUE}========================================${NC}"
                echo -e "${BLUE}           Config File                  ${NC}"
                echo -e "${BLUE}========================================${NC}"
                echo -e "${YELLOW}$CONFIG_FILE${NC}"
                cat "$CONFIG_FILE"
                echo ""
                read -p "Press Enter to return..." dummy
                ;;
            b|B) return ;;
            *) echo -e "${RED}Invalid option.${NC}" ;;
        esac
    done
}

show_help() {
    clear
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}      About Termux Whisper              ${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo "A high-performance wrapper for whisper.cpp."
    echo ""
    echo -e "${YELLOW}Transcripts saved to:${NC}"
    echo "/sdcard/Download/Termux-Whisper/"
    echo ""
    echo "Developed for Termux."
    read -p "Press Enter to return..." dummy
}

# Main Loop
while true; do
    print_header
    print_menu
    read -p "Select option: " selection
    
    case $selection in
        1) bash "$TRANS_SCRIPT" --file-picker ;; 
        2) bash "$MODELS_SCRIPT" ;; 
        3) settings_menu ;; 
        4) show_help ;;
        q|Q) 
            echo "Bye!"
            exit 0 
            ;;
        *) 
            echo -e "${RED}Invalid selection.${NC}" 
            ;;
    esac
done
