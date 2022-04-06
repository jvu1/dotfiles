dotfiles
========

Here is a simple set of configuration files for OSX.

OSX install
--------

    # Install dependencies
    brew install vim fish git the_silver_searcher tmux gh starship

    brew tap homebrew/cask-fonts
    brew install --cask font-hack-nerd-font
    brew install --cask font-fira-code-nerd-font

    # Setup fish (Intel)
    sudo 'echo /usr/local/bin/fish >> /etc/shells'
    chsh -s /usr/local/bin/fish

    # Setup fish (Apple Silicon)
    sudo 'echo /opt/homebrew/bin/fish  >> /etc/shells'
    chsh -s /opt/homebrew/bin/fish
    
    # Install the dotfiles
    mkdir -p ~/local/src
    cd ~/local/src
    git clone git@github.com/Nthalk/dotfiles
    ./install.sh

