fish_vi_key_bindings

abbr dotfiles 'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
abbr dc docker-compose
abbr g git
abbr gs 'git status'
abbr k clear

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

if test -d $HOME/.pyenv/bin
  set -x PATH $HOME/.pyenv/bin $PATH

  status --is-interactive; and . (pyenv init -|psub)
  status --is-interactive; and . (pyenv virtualenv-init -|psub)
end

if test -d /opt/homebrew/bin
  set -x PATH /opt/homebrew/bin $PATH
end

if test -d $HOME/google-cloud-sdk/bin
  set -x PATH $HOME/google-cloud-sdk/bin $PATH
end

set -Ux FZF_DEFAULT_COMMAND 'rg --files --glob "!.git/*"'
set -Ux FZF_FIND_FILE_COMMAND "$FZF_DEFAULT_COMMAND"
set -Ux FZF_CD_COMMAND "$FZF_DEFAULT_COMMAND"
set -Ux FZF_CD_WITH_HIDDEN_COMMAND "$FZF_DEFAULT_COMMAND --hidden"
set -Ux FZF_DEFAULT_OPTS '--bind ctrl-a:select-all,ctrl-d:deselect-all'
set -Ux VAULT_ADDR 'https://vault.goval.replit.com'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/moudy/google-cloud-sdk/path.fish.inc' ]; . '/Users/moudy/google-cloud-sdk/path.fish.inc'; end



# pnpm
set -gx PNPM_HOME "/Users/moudy/Library/pnpm"
set -gx PATH "$PNPM_HOME" $PATH
# pnpm end
# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/fish/__tabtab.fish ]; and . ~/.config/tabtab/fish/__tabtab.fish; or true
