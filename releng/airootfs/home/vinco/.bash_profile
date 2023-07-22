#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# Live boot configurations
if [ ! -f "$HOME/.vinco-lock" ]; then
    touch "$HOME/.vinco-lock"

    echo "[INFO] Setting Vinco Linux live boot environment..."

    # Locale
    sudo locale-gen

    # Permissions
    chmod -R +x "$HOME/.local/bin/tor-browser"
    chmod +x "$HOME/Desktop/start-tor-browser.desktop"
    chmod +x "$HOME/Desktop/Firefox Browser Web.desktop"
    chmod +x "$HOME/Desktop/GParted.desktop"

    echo "[INFO] Done."
fi

# Start Desktop Environment
startx
