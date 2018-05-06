#!/usr/bin/env bash

ROOT_DIR="$PWD"
FILES_DIR="$ROOT_DIR/files"
INSTALL_DIR="$ROOT_DIR/_install"
LOGS_DIR="$INSTALL_DIR/logs"
SRC_DIR="$INSTALL_DIR/src"
LUADIST_BOOTSTRAP_DIR="$INSTALL_DIR/_luadist_bootstrap"

mkdir -p $LOGS_DIR
mkdir -p $SRC_DIR
cd $SRC_DIR

# Get needed modules
git clone "https://github.com/LuaDist-core/github-pusher" github-pusher
git clone "https://github.com/LuaDist-core/git2travis" git2travis
git clone "https://github.com/LuaDist-core/rocks2git" rocks2git

cp -r "$FILES_DIR/." "$INSTALL_DIR"

# Print success messages.
echo "## LunaCI is now built inside $INSTALL_DIR."
echo "## You should now review and edit the env.list file."
echo "## When you're ready, run LunaCI inside Docker."

