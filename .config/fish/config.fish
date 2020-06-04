fish_vi_key_bindings

# set -U fish_color_command green

abbr dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
abbr dc docker-compose
abbr g git
abbr gs 'git status'
abbr k clear
abbr vim nvim

if test -d /usr/local/go/bin
  set -x PATH /usr/local/go/bin $PATH
end

if test -d $HOME/.cargo/bin
  set -x PATH $HOME/.cargo/bin $PATH
end

if test -d $HOME/go/bin
  set -x PATH $HOME/go/bin $PATH
end

if test -d /snap/bin
  set -x PATH /snap/bin $PATH
end

if test -d $HOME/bin
  set -x PATH $HOME/bin $PATH
end

set pure_color_primary cyan
set pure_color_mute blue
set pure_color_git_branch white
set pure_color_git_dirty white
