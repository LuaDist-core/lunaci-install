#!/usr/bin/env bash

SRC_DIR="$HOME/src"
IMPORT_LUA="$HOME/luadist/bin/lua"
LOG_DIR="$HOME/logs"

ROCKS2GIT_MIRROR_URL="https://github.com/rocks-moonscript-org/moonrocks-mirror.git"

export ROCKS2GIT_BASE_DIR="$HOME/src"
export ROCKS2GIT_DATA_DIR="$HOME/data"

export ROCKS2GIT_MIRROR_DIR="$ROCKS2GIT_DATA_DIR/luarocks-mirror"
MANIFEST_DIR="$ROCKS2GIT_DATA_DIR/manifest"
export ROCKS2GIT_REPO_DIR="$ROCKS2GIT_DATA_DIR/repos"
export ROCKS2GIT_TEMP_DIR="$ROCKS2GIT_DATA_DIR/tmp"
export ROCKS2GIT_MANIFEST_FILE="$MANIFEST_DIR/manifest-file"
export ROCKS2GIT_BLACKLIST_FILE="$ROCKS2GIT_DATA_DIR/module-blacklist"

export ROCKS2GIT_TRAVIS_FILE="$ROCKS2GIT_BASE_DIR/rocks2git/travis_file.yml"
export ROCKS2GIT_LOG_DIR="$LOG_DIR/rocks2git"

export ROCKS2GIT_GIT_USER_NAME="LunaCI"
export ROCKS2GIT_GIT_USER_MAIL="lunaci@luadist.org"
export ROCKS2GIT_GIT_MODULE_SOURCE="git://github.com/$GITHUB_ORG_NAME/%s.git"


export PUSHER_REPO_PATH="$ROCKS2GIT_DATA_DIR/repos"
export PUSHER_LOG_DIR="$LOG_DIR/pusher"
export PUSHER_ORG_NAME="$GITHUB_ORG_NAME"
export PUSHER_GITHUB_TOKEN="$GITHUB_TOKEN"


export GIT2TRAVIS_REPO_PATH="$PUSHER_REPO_PATH"
export GIT2TRAVIS_LOG_DIR="$LOG_DIR/git2travis"
export GIT2TRAVIS_TRAVIS_TOKEN="$TRAVIS_TOKEN"
export GIT2TRAVIS_GITHUB_TOKEN="$GITHUB_TOKEN"
export GIT2TRAVIS_GITHUB_DIR="$GITHUB_ORG_NAME"
export GIT2TRAVIS_TRAVIS_SYNC_WAIT=30
export GIT2TRAVIS_TRAVIS_MAX_TRIES=5

# Prepare the environment
mkdir -p "$ROCKS2GIT_MIRROR_DIR"
cd "$ROCKS2GIT_MIRROR_DIR"

git init
remotes=$(git remote)
for remote in $remotes
do
  git remote rm $remote
done
git remote add origin "$ROCKS2GIT_MIRROR_URL"

mkdir -p "$MANIFEST_DIR"
mkdir -p "$ROCKS2GIT_REPO_DIR"
mkdir -p "$ROCKS2GIT_TEMP_DIR"

mkdir -p "$ROCKS2GIT_LOG_DIR"
mkdir -p "$PUSHER_LOG_DIR"
mkdir -p "$GIT2TRAVIS_LOG_DIR"


# Run rocks2git
cd "$SRC_DIR/rocks2git"

$IMPORT_LUA ./rocks2git.lua

# Run github-pusher
cd "$SRC_DIR/github-pusher"

$IMPORT_LUA ./pusher.lua

# Commit and push the Manifest file
cd "$MANIFEST_DIR"

git init
git config --local user.name $ROCKS2GIT_GIT_USER_NAME
git config --local user.email $ROCKS2GIT_GIT_USER_MAIL

remotes=$(git remote)
for remote in $remotes
do
  git remote rm $remote
done

git remote add origin https://$PUSHER_GITHUB_TOKEN@github.com/$GITHUB_ORG_NAME/manifest.git
git add --all
git commit -m 'Update Manifest file'
git push origin master

# Run git2travis
cd "$SRC_DIR/git2travis"

$IMPORT_LUA ./git2travis.lua

