# Homer

[![Build Status](https://travis-ci.org/emilsoman/homer.png?branch=master)](https://travis-ci.org/emilsoman/homer)
[![Coverage Status](https://coveralls.io/repos/emilsoman/homer/badge.png?branch=master)](https://coveralls.io/r/emilsoman/homer)

Homer makes tracking your Unix dotfiles easay peasay
With homer you can :

1. Track your dotfiles on git.
2. Easily swap dotfiles with another set.

## *Under development*


## Installation
```sh
gem install homer
homer init <github_username>/<repository_name>
```
This will:

1. Create a directory named `~/.homer/github_username/repository_name`
3. Runs `git init` in the newly created directory

## Usage

*Note: Some of these features are still under development*

- Start tracking dotfiles :

        homer add ~/.vimrc

  This does the following:

  1. Moves `~/.vimrc` to your homer dotfiles directory
  2. Creates a symlink at  `~/.vimrc` to point to `.vimrc` in your dotfiles
     directory
  3. Adds a Homerfile entry in your dotfiles repo
  4. git-commits your dotfiles directory

- List tracked files :

        homer list

- Sync dotfiles repo with GitHub

        homer sync

A few days later ..

Need to pair program and on a hostile box ?
Want to use somebody's dotfiles repo you saw on GitHub ?

        homer use <github_username>/<repo_name>

Rollback and use the your own dotfiles ?

        homer use mine

## License

MIT
