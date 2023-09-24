#!/usr/bin/env bash

PROJECT_FOLDER="$(pwd)"
MKARCHISO="$PROJECT_FOLDER/bin/archiso/mkarchiso"
TEMP_ISO_FOLDER="$PROJECT_FOLDER/out/tmp"
ISO_FOLDER="$PROJECT_FOLDER/out"
BIN_FOLDER="$PROJECT_FOLDER/releng/airootfs/home/vinco/.local/bin"

TEMP_FOLDER="./tmp/vincolinux-tmp"
CLONE_FOLDER="$TEMP_FOLDER/clone"
REPO_FOLDER="$TEMP_FOLDER/repo"

case "$1" in
    "iso")
        if [ "$EUID" -ne 0 ]; then
            echo "[ERROR] \"$0 iso\" has to be run as root"
            exit
        fi

        $MKARCHISO -v -w $TEMP_ISO_FOLDER -o $ISO_FOLDER "$PROJECT_FOLDER/releng"
        exit
        ;;
    "configure")
        mkdir -p $CLONE_FOLDER
        mkdir -p $REPO_FOLDER
        mkdir -p $ISO_FOLDER
        mkdir -p $BIN_FOLDER

        # TODO: organize dependencies
        wget -q --show-progress -P $CLONE_FOLDER "https://www.torproject.org/dist/torbrowser/12.5.1/tor-browser-linux64-12.5.1_ALL.tar.xz"
        tar -C $BIN_FOLDER -xf "$CLONE_FOLDER/tor-browser-linux64-12.5.1_ALL.tar.xz"

        cd $CLONE_FOLDER
        git clone "https://aur.archlinux.org/rtl88xxau-aircrack-dkms-git.git"
        cd "rtl88xxau-aircrack-dkms-git"
        makepkg
        cd $PROJECT_FOLDER
        find "$CLONE_FOLDER/rtl88xxau-aircrack-dkms-git/" -name "*.tar.zst" -exec cp -prv "{}" "$REPO_FOLDER" ";"
        find "$REPO_FOLDER" -name "*.tar.zst" -exec repo-add "$REPO_FOLDER/custom.db.tar.gz" "{}" ";"

        exit
        ;;
    "clean")
        if [ "$EUID" -ne 0 ]; then
            echo "[ERROR] \"$0 clean\" has to be run as root"
            exit
        fi

        rm -rf $TEMP_FOLDER
        rm -rf $TEMP_ISO_FOLDER
        rm -rf "$BIN_FOLDER/tor-browser"

        echo "[INFO] Done."
        exit
        ;;
    *)
        echo "Usage: $0 iso|configure|clean"
        ;;
esac
