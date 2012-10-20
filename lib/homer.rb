require 'homer/file_layer'
require 'homer/github_layer'
require 'homer/symlink'

class Homer

  class << self

    def init
      FileLayer.prepare_homer_folder
    end

    def wipe
      FileLayer.delete_homer_folder
    end

    def add(dotfile)
      FileLayer.prepare_homer_folder
      SymLink.add(dotfile)
    end

    def list
      SymLink.filenames
    end

    def push
      dotfiles_dir = FileLayer.dotfiles_directory_path
      GitHubLayer.push(dotfiles_dir)
    end

  end

end

