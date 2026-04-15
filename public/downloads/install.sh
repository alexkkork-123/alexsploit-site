#!/usr/bin/env bash

# AlexSploit Installer — macOS (ARM64 + x86_64)

set -euo pipefail

R='\033[0;31m'
G='\033[0;32m'
Y='\033[1;33m'
M='\033[0;35m'
C='\033[0;36m'
W='\033[1;37m'
D='\033[2m'
BD='\033[1m'
N='\033[0m'

die()  { echo -e "\n ${R}✖  $*${N}\n"; exit 1; }
ok()   { echo -e " ${G}✔${N}  $*"; }
info() { echo -e " ${C}→${N}  $*"; }
warn() { echo -e " ${Y}⚠${N}  $*"; }
step() { echo -e "\n ${M}${BD}[$1/${TOTAL_STEPS}]${N} ${BD}$2${N}"; }

TOTAL_STEPS=6
VERSION="version-08d2b9589bf14135"
CDN="https://alexsploit.com/downloads"

if [ -w "/Applications" ]; then
    APP_DIR="/Applications"
else
    APP_DIR="$HOME/Applications"
    mkdir -p "$APP_DIR"
fi

TEMP="$(mktemp -d)"
trap 'rm -rf "$TEMP"' EXIT

banner() {
    clear
    echo ""
    echo -e "${R}    ▄▄▄       ${M}██▓    ${C}▓█████  ${G}▒██   ██▒${N}"
    echo -e "${R}   ▒████▄     ${M}▓██▒    ${C}▓█   ▀  ${G}▒▒ █ █ ▒░${N}"
    echo -e "${R}   ▒██  ▀█▄   ${M}▒██░    ${C}▒███    ${G}░░  █   ░${N}"
    echo -e "${R}   ░██▄▄▄▄██  ${M}▒██░    ${C}▒▓█  ▄  ${G} ░ █ █ ▒ ${N}"
    echo -e "${R}    ▓█   ▓██▒ ${M}░██████▒${C}░▒████▒ ${G}▒██▒ ▒██▒${N}"
    echo -e "${R}    ▒▒   ▓▒█░ ${M}░ ▒░▓  ░${C}░░ ▒░ ░ ${G}▒▒ ░ ░▓ ░${N}"
    echo -e "${R}     ▒   ▒▒ ░ ${M}░ ░ ▒  ░${C} ░ ░  ░ ${G}░░   ░▒ ░${N}"
    echo -e "${R}     ░   ▒    ${M}  ░ ░   ${C}   ░    ${G} ░    ░  ${N}"
    echo -e "${R}         ░  ░ ${M}    ░  ░${C}   ░  ░ ${G} ░    ░  ${N}"
    echo ""
    echo -e "    ${W}${BD}╔══════════════════════════════════════════════╗${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}║${N}     ${C}${BD}A L E X S P L O I T${N}   ${D}v1.0.0${N}              ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║${N}     ${D}macOS Roblox Executor${N}                     ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}╚══════════════════════════════════════════════╝${N}"
    echo ""
}

main() {
    banner

    step 1 "Preflight"

    ARCH="$(uname -m)"
    if [[ "$ARCH" == "arm64" ]]; then
        ROBLOX_URL="https://setup.rbxcdn.com/mac/arm64/${VERSION}-RobloxPlayer.zip"
    elif [[ "$ARCH" == "x86_64" ]]; then
        ROBLOX_URL="https://setup.rbxcdn.com/mac/${VERSION}-RobloxPlayer.zip"
    else
        die "Unsupported architecture: $ARCH"
    fi
    ok "Architecture: $ARCH"
    ok "macOS $(sw_vers -productVersion)"

    step 2 "Preparing environment"
    killall -9 RobloxPlayer 2>/dev/null && warn "Killed running Roblox" || ok "No Roblox running"
    mkdir -p ~/Documents/AlexSploit
    for target in "$APP_DIR/Roblox.app" "$APP_DIR/RobloxPlayer.app"; do
        [ -e "$target" ] && rm -rf "$target" 2>/dev/null && ok "Removed $(basename "$target")"
    done
    ok "Clean"

    step 3 "Downloading"

    info "Roblox ($ARCH)..."
    curl -L --progress-bar "$ROBLOX_URL" -o "$TEMP/RobloxPlayer.zip"
    [ -s "$TEMP/RobloxPlayer.zip" ] || die "Roblox download failed"
    ok "Roblox"

    info "AlexSploit dylib..."
    curl -L --progress-bar "$CDN/libAlexSploit.dylib" -o "$TEMP/libAlexSploit.dylib"
    [ -s "$TEMP/libAlexSploit.dylib" ] || die "Dylib download failed"
    ok "Dylib"

    info "AlexSploit app..."
    curl -L --progress-bar "$CDN/AlexSploit-1.0.0-arm64.dmg" -o "$TEMP/AlexSploit.dmg"
    [ -s "$TEMP/AlexSploit.dmg" ] || die "DMG download failed"
    ok "App"

    info "insert_dylib..."
    curl -L --progress-bar "$CDN/insert_dylib" -o "$TEMP/insert_dylib"
    chmod +x "$TEMP/insert_dylib"
    [ -x "$TEMP/insert_dylib" ] || die "insert_dylib download failed"
    ok "insert_dylib"

    step 4 "Injecting"

    info "Extracting Roblox..."
    unzip -oq "$TEMP/RobloxPlayer.zip" -d "$TEMP"
    local extracted_app
    extracted_app=$(find "$TEMP" -maxdepth 2 -name "*.app" -type d | head -1)
    [ -n "$extracted_app" ] || die "No .app found in zip"
    mv "$extracted_app" "$APP_DIR/Roblox.app"
    xattr -cr "$APP_DIR/Roblox.app"
    ok "Roblox extracted"

    local ROBLOX_APP="$APP_DIR/Roblox.app"
    local ROBLOX_BIN="$ROBLOX_APP/Contents/MacOS/RobloxPlayer"

    cp "$ROBLOX_BIN" "${ROBLOX_BIN}.backup"
    cp "$TEMP/libAlexSploit.dylib" "$ROBLOX_APP/Contents/MacOS/libAlexSploit.dylib"

    info "Injecting dylib..."
    "$TEMP/insert_dylib" --strip-codesig --all-yes \
        "@executable_path/libAlexSploit.dylib" "$ROBLOX_BIN" "$ROBLOX_BIN"

    otool -L "$ROBLOX_BIN" 2>/dev/null | grep -qi "alexsploit" || die "Injection failed"
    ok "Dylib injected"

    step 5 "Signing"
    xattr -cr "$ROBLOX_APP"
    codesign -f -s - --deep --preserve-metadata=entitlements "$ROBLOX_APP"
    xattr -cr "$ROBLOX_APP"
    ok "Signed"

    rm -rf "$ROBLOX_APP/Contents/MacOS/RobloxPlayerInstaller.app" 2>/dev/null || true
    defaults write com.Roblox.RobloxPlayer AppUpdateStatus -string "NotAvailable" 2>/dev/null || true
    ok "Auto-updater disabled"

    /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
        -f "$ROBLOX_APP" 2>/dev/null || true
    ok "URL scheme registered"

    step 6 "Installing AlexSploit app"
    info "Mounting DMG..."
    local mount_point
    mount_point=$(hdiutil attach "$TEMP/AlexSploit.dmg" -nobrowse -noverify 2>/dev/null | grep "/Volumes" | awk -F'\t' '{print $NF}')
    if [ -n "$mount_point" ]; then
        local app_in_dmg
        app_in_dmg=$(find "$mount_point" -maxdepth 1 -name "*.app" -type d | head -1)
        if [ -n "$app_in_dmg" ]; then
            rm -rf "$APP_DIR/AlexSploit.app" 2>/dev/null || true
            cp -R "$app_in_dmg" "$APP_DIR/AlexSploit.app"
            xattr -cr "$APP_DIR/AlexSploit.app"
            ok "AlexSploit.app installed"
        else
            warn "No .app found in DMG"
        fi
        hdiutil detach "$mount_point" -quiet 2>/dev/null || true
    else
        warn "Could not mount DMG"
    fi

    info "Launching Roblox..."
    "$ROBLOX_BIN" &
    disown

    echo ""
    echo -e "    ${W}${BD}╔══════════════════════════════════════════════╗${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}║${N}  ${G}${BD}✔  AlexSploit installed successfully${N}        ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}║${N}  ${C}App:${N} Open ${W}AlexSploit${N} from Applications    ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║${N}  ${C}Log:${N} ~/Documents/AlexSploit/              ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║${N}  ${Y}⚠  Use an alt account${N}                     ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}╚══════════════════════════════════════════════╝${N}"
    echo ""
}

main
