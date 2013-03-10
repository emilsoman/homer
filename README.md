# Homer


Homer makes tracking your Unix dotfiles easay peasay

master branch : [![Build Status](https://travis-ci.org/emilsoman/homer.png?branch=master)](https://travis-ci.org/emilsoman/homer)  
refactor branch : [![Build Status](https://travis-ci.org/emilsoman/homer.png?branch=refactor)](https://travis-ci.org/emilsoman/homer)

## *Under development. Risky to use till this line is gone*


## Installation

    gem install homer
## Usage

- Start tracking dotfiles :

        homer add ~/.vimrc
- List tracked files :

        homer list
- Push tracked files to GitHub

        homer push

A few days later ..

Need to pair program at co-worker's hostile box .

- To turn on ninja mode at hostile box:

        homer hi <github login>
- When friend complains after your display of awesomeness

        homer bye
        
## Wishlist
- Use a table for listing tracked files and Symlinks ( Use [terminal table](https://github.com/visionmedia/terminal-table) ? )
