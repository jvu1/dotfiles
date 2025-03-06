dotfiles
========

Here is a simple set of configuration files for OSX.

OSX install
--------

    # Install dependencies
    brew install bat btop eza fish fzf gh git git-delta magic-wormhole mcfly starship tmux vim zoxide

    brew install --cask 1password appcleaner arc chatgpt coscreen claude ghostty iterm2 logi-options+ ngrok numi obsidian postman raycast sublime-text stats sublime-text the-unarchiver topnotch visualvm
    brew install --cask font-hack-nerd-font
    brew install --cask font-fira-code-nerd-font

    # Setup fish (Intel)
    sudo 'echo /usr/local/bin/fish >> /etc/shells'
    chsh -s /usr/local/bin/fish

    # Setup fish (Apple Silicon)
    sudo nano /etc/shells
    # Add `/opt/homebrew/bin/fish` at the end of the file
    chsh -s /opt/homebrew/bin/fish
    
    # Install the dotfiles
    mkdir -p ~/local/src
    cd ~/local/src
    git clone git@github.com:jvu1/dotfiles.git
    ./install.sh
