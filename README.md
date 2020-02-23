## Dotfiles Setup

> The technique consists in storing a Git bare repository in a "side" folder (like $HOME/.cfg or $HOME/.myconfig) using a specially crafted alias so that commands are run against that repository and not the usual .git local folder, which would interfere with any other Git repositories around.
https://www.atlassian.com/git/tutorials/dotfiles

### Starting from scratch

```sh
# create ~/.dotfiles folder as a Git bare repository
git init --bare $HOME/.dotfiles

# create an alias (or fish function) for git interactions (save in .bashrc or wherever)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# set a flag for the repository to hide files not explicitly tracking
dotifles config --local status.showUntrackedFiles no
```

### Install your dotfiles onto a new system

```sh
# create an alias (or fish function) for git interactions (save in .bashrc or wherever)
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# clone repo
git clone --bare <git-repo-url> $HOME/.dotfiles

# checkout content from the bare repository to your $HOME
# might have to remove existing files
dotfiles checkout

# set a flag for the repository to hide files not explicitly tracking
dotfiles config --local status.showUntrackedFiles no
```

### Managing dotfiles

To manage dotfiles replace `git` with `dotfiles`.

```sh
dotfiles status
dotfiles add .vimrc
dotfiles commit -m "Add vimrc"
dotfiles push
```

## Fish Shell Setup

Install [fish](https://fishshell.com/) and [fisher](https://github.com/jorgebucaran/fisher).
