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

if ! hash brew >> /dev/null; then
    echo 'Installing homebrew...'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo 'Installing brew packages and GUI apps'
brew install asdf bat btop dust cloudflared eza fd fish fzf gh git git-delta glow magic-wormhole mcfly ripgrep sd starship tmux vim zoxide
brew install --cask 1password appcleaner arc chatgpt ghostty logi-options+ numi obsidian postman raycast sublime-text stats the-unarchiver topnotch visualvm

# Add /opt/homebrew/bin/fish to /etc/shells (if not already present), then set it as default shell
grep -qxF '/opt/homebrew/bin/fish' /etc/shells || echo '/opt/homebrew/bin/fish' | sudo tee -a /etc/shells > /dev/null
chsh -s /opt/homebrew/bin/fish

load $HOME/.tmux.conf $DOTDIR/tmux.conf
load $HOME/.vimrc $DOTDIR/vimrc
load $HOME/.vim $DOTDIR/vim
load $HOME/.config/fish $DOTDIR/fish
load $HOME/local/src/dotfiles/tabby/config.yaml $HOME/Library/Application\ Support/tabby/config.yaml
load $HOME/local/src/dotfiles/ghostty/config $HOME/Library/Application\ Support/com.mitchellh.ghostty/config

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
