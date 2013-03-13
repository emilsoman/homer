# Homer

Homer makes tracking your Unix dotfiles easay peasay

[![Build Status](https://travis-ci.org/emilsoman/homer.png?branch=master)](https://travis-ci.org/emilsoman/homer)
[![Coverage Status](https://coveralls.io/repos/emilsoman/homer/badge.png?branch=master)](https://coveralls.io/r/emilsoman/homer)

## *Under development*


## Installation
```sh
gem install homer
homer init
```
This will:

1. Move your dotfiles to `~/.homer/github_username/dotfiles`
2. Create symlinks to places where the files originally belonged
3. Create a repository on GitHub
4. Push all your dotfiles there.
    
## Usage

- Start tracking dotfiles :

        homer add ~/.vimrc
- List tracked files :

        homer list
- Sync with GitHub

        homer sync

A few days later ..

Need to pair program and code at co-worker's hostile box ?  
Want to use somebody's dotfiles repo you saw on GitHub ?

        homer hi <github login>

Rollback and use your original dotfiles ?

        homer bye
        
## License

MIT
