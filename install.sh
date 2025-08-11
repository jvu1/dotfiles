#!/bin/bash
TS=$(date +%s)
DOTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function load {
  TO=$1
  FROM=$2
  echo $TO
  if [ -L $TO ]; then
    echo "Removing stale link"
    rm $TO
  fi
  if [ -e $TO ]; then
    echo "Backing up: $TO"
    mv $TO $TO.old.$TS
  fi
  echo "Updating $TO with $FROM"
  ln -s $FROM $TO
}

echo "Creating default directories"
mkdir -p $HOME/local/src
mkdir -p $HOME/local/bin
mkdir -p $HOME/local/inst
mkdir -p $HOME/local/tmp
mkdir -p $HOME/.config

load $HOME/.tmux.conf $DOTDIR/tmux.conf
load $HOME/.vimrc $DOTDIR/vimrc
load $HOME/.emacs $DOTDIR/emacs
load $HOME/.vim $DOTDIR/vim
load $HOME/.config/fish $DOTDIR/fish
load $HOME/local/src/dotfiles/tabby/config.yaml $HOME/Library/Application\ Support/tabby/config.yaml

# Include ~/.bashrc in ~/.bash_profile
bashrc_include='[[ -s ~/.bashrc ]] && source ~/.bashrc'
if [ -e $HOME/.bash_profile ]; then
  if ! grep -q 'source ~/.bashrc' $HOME/.bash_profile; then
    echo "~/.bash_profile: adding include to ~/.bashrc"
    echo $bashrc_include >> $HOME/.bash_profile
  else
    echo "~/.bash_profile: already includes ~/.bashrc"
  fi
else
  echo "~/.bash_profile: adding file to include ~/.bashrc"
  echo $bashrc_include >> $HOME/.bash_profile
fi

# Conditionally add DOTDIR/bin to PATH
if [ -e $HOME/.bashrc ]; then
  if ! grep -q "$DOTDIR/bin" $HOME/.bashrc; then
    echo 'export PATH='$DOTDIR/bin':$PATH' >> $HOME/.bashrc
  fi
else
  echo 'export PATH='$DOTDIR/bin':$PATH' > $HOME/.bashrc
fi

# Conditionally add gitconfig
gitconfig=$gitconfig"[include]\n  path = $DOTDIR/gitconfig"
if [ -e $HOME/.gitconfig ]; then
  if ! grep -q "path = $DOTDIR/gitconfig" $HOME/.gitconfig; then
    echo -e $gitconfig >> $HOME/.gitconfig
  fi
else
  echo -e $gitconfig > $HOME/.gitconfig
fi

load $HOME/.gitignore $DOTDIR/gitignore
