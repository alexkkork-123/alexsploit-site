#!/usr/bin/env bash

# AlexSploit — ARM64 macOS Installer

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

TOTAL_STEPS=8
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
    echo -e "    ${W}${BD}║${N}     ${D}ARM64 macOS Roblox Executor${N}               ${W}${BD}║${N}"
    echo -e "    ${W}${BD}║                                              ║${N}"
    echo -e "    ${W}${BD}╚══════════════════════════════════════════════╝${N}"
    echo ""
}

main() {
    banner

    step 1 "Preflight checks"

    [[ "$(uname -m)" == "arm64" ]] || die "Apple Silicon (ARM64) required"
    ok "Architecture: arm64"

    if ! xcode-select -p &>/dev/null; then
        warn "Installing Xcode CLT..."
        xcode-select --install
        die "Rerun after Xcode CLT finishes installing"
    fi
    ok "Xcode CLT installed"

    step 2 "Preparing environment"
    killall -9 RobloxPlayer 2>/dev/null && warn "Killed running Roblox" || ok "No Roblox running"
    mkdir -p ~/Documents/AlexSploit

    step 3 "Removing old Roblox"
    for target in "$APP_DIR/Roblox.app" "$APP_DIR/RobloxPlayer.app"; do
        if [ -e "$target" ]; then
            rm -rf "$target" 2>/dev/null || true
            ok "Removed $(basename "$target")"
        fi
    done
    ok "Clean slate"

    step 4 "Downloading Roblox ARM64"
    info "Version: ${VERSION}"
    curl -L --progress-bar "https://setup.rbxcdn.com/mac/arm64/${VERSION}-RobloxPlayer.zip" -o "$TEMP/RobloxPlayer.zip"
    [ -s "$TEMP/RobloxPlayer.zip" ] || die "Download failed"
    ok "Downloaded Roblox"

    info "Extracting..."
    unzip -oq "$TEMP/RobloxPlayer.zip" -d "$TEMP"
    local extracted_app
    extracted_app=$(find "$TEMP" -maxdepth 2 -name "*.app" -type d | head -1)
    [ -n "$extracted_app" ] || die "No .app found in zip"
    mv "$extracted_app" "$APP_DIR/Roblox.app"
    xattr -cr "$APP_DIR/Roblox.app"
    ok "Roblox installed"

    local ROBLOX_APP="$APP_DIR/Roblox.app"
    local ROBLOX_BIN="$ROBLOX_APP/Contents/MacOS/RobloxPlayer"

    step 5 "Downloading AlexSploit"
    info "Fetching dylib..."
    curl -L --progress-bar "$CDN/libAlexSploit.dylib" -o "$TEMP/libAlexSploit.dylib"
    [ -s "$TEMP/libAlexSploit.dylib" ] || die "Dylib download failed"
    ok "Downloaded dylib"

    info "Fetching app..."
    curl -L --progress-bar "$CDN/AlexSploit-1.0.0-arm64.dmg" -o "$TEMP/AlexSploit.dmg"
    [ -s "$TEMP/AlexSploit.dmg" ] || die "DMG download failed"
    ok "Downloaded app"

    step 6 "Injecting AlexSploit"
    local INSERT_DYLIB="/tmp/insert_dylib_bin"
    if [ ! -x "$INSERT_DYLIB" ]; then
        info "Building insert_dylib..."
        cd /tmp && rm -rf insert_dylib
        git clone --quiet https://github.com/tyilo/insert_dylib.git
        clang -o "$INSERT_DYLIB" insert_dylib/insert_dylib/main.c -framework Foundation
        rm -rf insert_dylib
    fi
    ok "insert_dylib ready"

    cp "$ROBLOX_BIN" "${ROBLOX_BIN}.backup"
    cp "$TEMP/libAlexSploit.dylib" "$ROBLOX_APP/Contents/MacOS/libAlexSploit.dylib"

    "$INSERT_DYLIB" --strip-codesig --all-yes \
        "@executable_path/libAlexSploit.dylib" "$ROBLOX_BIN" "$ROBLOX_BIN"

    otool -L "$ROBLOX_BIN" 2>/dev/null | grep -qi "alexsploit" || die "Injection failed"
    ok "Dylib injected"

    step 7 "Signing & finalizing"
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

    step 8 "Installing AlexSploit app"
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
