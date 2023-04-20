################################################################################
# Functions

# CD Helper
function cd --description "Change working directory"
  builtin cd $argv
  emit cwd
end

function addPath --description 'Add path if it exists and is not already in PATH, also sets an ENV variable with a second param'
  set -l dir $argv[1]
  set -l key $argv[2]

  if test -d $dir
    if not test -z "$key"
      set $key $dir
    end
    if not contains $dir $PATH
      set PATH $PATH $dir
    end
  end
end

function setFirstAvailablePath --description 'Set a variable to the first available path if it exists'
  set -l key $argv[1]
  for i in $argv[2..-1]
    set -l dir "$i"
    if test -e "$dir"
      set -g -x "$key" "$dir"
      break
    end
  end
end

################################################################################
# Environment variables / Path

# PWD bin
set PATH ./bin $PATH
set PATH ./node_modules/.bin $PATH

# Dotfiles bin
addPath (dirname (status -f))"/../bin"
addPath $HOME/local/bin

# Homebrew bin (Intel)
addPath /usr/local/sbin
addPath /usr/local/bin
# Homebrew bin (Apple M1 Silicon)
addPath /opt/homebrew/bin
addPath /opt/homebrew/sbin

# Android
setFirstAvailablePath ANDROID_HOME $HOME/Library/Android/sdk /usr/local/share/android-sdk
addPath "$ANDROID_HOME/tools/bin"
addPath "$ANDROID_HOME/tools"
addPath "$ANDROID_HOME/platform-tools"

addPath /usr/local/share/android-ndk ANDROID_NDK_HOME

################################################################################
# Git SSH
set -x GIT_SSH git-ssh

################################################################################
# Make flags
set CPPFLAGS '-I$HOME/local/include'
set CFLAGS '-I$HOME/local/include'
set LDFLAGS '-L$HOME/local/lib'

################################################################################
# Vim

# Use vim as the default editor
if type vim 1>/dev/null
  set -x EDITOR 'vim'
end

################################################################################
# Abbreviations

# Git
abbr g "git"
abbr gpr 'git pull-request'
abbr gcm 'git checkout (git_main_branch)'
abbr grm 'git rebase (git_main_branch)'
abbr gp 'git pull'
abbr gcb 'git checkout -b'
abbr gb 'git branch'
abbr gd 'git diff'
abbr gs 'git status'
abbr gst 'git stash'
abbr gr 'git rebase'
abbr ga 'git add'
abbr gl 'git log'
abbr gt 'git restore'
abbr grs 'git restore --staged'
abbr gco 'git checkout'
abbr gc 'git commit'
abbr gps 'git push'
abbr gcp 'git cherry-pick'

# ls
abbr l ls
abbr ll ls -la

# Android
abbr droid 'adb shell input text'

# Misc. Productivity
abbr work 'cd ~/local/src/'

# Network
abbr port 'lsof -i tcp:'
abbr ip 'ifconfig | grep "inet " | grep -v 127.0.0.1'

################################################################################
# Customization support

if test -f "$HOME/.config/fish/custom.fish"
  source "$HOME/.config/fish/custom.fish"
end
