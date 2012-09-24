require 'fileutils'

class FileLayer
  class << self

    def save_authorization_token(token)
      f = File.open(token_path, "a")
      f.puts token
      f.close
    rescue Exception => e
      raise "GitHub token could not be saved : Error : #{e.message}"
    end 

    def prepare_homer_folder
      Dir.mkdir(File.join(Dir.home, ".homer"))
      File.new(dotfiles_path , "w")
    rescue Exception => e
      raise "~/.homer cannot be created : #{e.message}"
    end

    def dotfiles_path
      return File.join(Dir.home, ".homer", "dotfiles")
    end

    def delete_homer_folder
      FileUtils.rm_rf(File.join(Dir.home, ".homer"))
    end 

    def read_dotfiles
      File.read(dotfiles_path)
    end

    def add_filename_to_dotfiles(dotfile)
      dotfile = File.expand_path(dotfile)
      f = File.open(dotfiles_path, "a")
      raise "#{dotfile} does not exist." unless File.exists?(dotfile)
      f.puts dotfile
      f.close
    end

    def root_path
      return File.join(Dir.home, ".homer")
    end

    def token_path
      File.join(root_path, "token")
    end

  end
end
