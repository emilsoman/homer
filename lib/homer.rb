require 'homer/file_layer'
require 'homer/github_layer'
require 'homer/symlink'

class Homer

  class << self

    def init
      FileLayer.init
      GitHubLayer.init(FileLayer.dotfiles_directory_path)
    end

    def wipe
      FileLayer.delete_homer_folder
    end

    def add(dotfile)
      FileLayer.prepare_homer_folder
      SymLink.add(dotfile)
    end

    def list
      SymLink.file_paths
    end

    def push
      dotfiles_dir = FileLayer.dotfiles_directory_path
      GitHubLayer.push(dotfiles_dir)
    end

    def hi(login)
      puts "Hi #{login}"
      room = FileLayer.make_room(login)
      puts "Your room is here : #{room}"
      Dir.chdir(room)
      puts "Getting all your dotfiles"
      GitHubLayer.get_dotfiles(login)
      puts "Getting your room ready"
      use(room)
      puts "Done! Be at home , #{login}"
    end

    def use(room)
      bye
      FileLayer.create_current_symlink(room)
    end

    def bye
      FileLayer.delete_current_symlinks
      FileLayer.restore_backup
    end
  end

end

