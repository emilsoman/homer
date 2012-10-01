require 'fileutils'
require 'homer/symlink'
require 'yaml'

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
      Dir.mkdir(File.join(Dir.home, ".homer")) unless Dir.exists?(File.join(Dir.home, ".homer"))
      Dir.mkdir(File.join(Dir.home, ".homer", "dotfiles")) unless Dir.exists?(File.join(Dir.home, ".homer", "dotfiles"))
      File.new(dotfiles_path , "w") unless File.exists?(dotfiles_path)
    rescue Exception => e
      raise "~/.homer cannot be created : #{e.message}"
    end

    def delete_homer_folder
      FileUtils.rm_rf(File.join(Dir.home, ".homer"))
    end 

    def add_filename_to_dotfiles(dotfile)
      dotfile = File.expand_path(dotfile)
      f = File.open(dotfiles_path, "a")
      raise "#{dotfile} does not exist." unless File.exists?(dotfile)
      f.puts dotfile
      f.close
    end

    def read_symlink_file
      return {} if !File.exists?(dotfiles_path) or File.zero?(dotfiles_path)
      YAML.load_file(dotfiles_path)
    end

    def save_symlink_file(symlinks)
      File.open(dotfiles_path,"w") do |out|
        YAML.dump(symlinks,out)
      end
    end

    def create_symlink(filename,file_path)
      FileUtils.mv(file_path, File.join(dotfiles_directory_path, filename))
      File.symlink(File.join(dotfiles_directory_path, filename), file_path)
    end

    def dotfiles_directory_path
      File.join(Dir.home, ".homer", "dotfiles", "/")
    end

    def dotfiles_path
      return File.join(Dir.home, ".homer", "dotfiles", "dotfiles_list")
    end

    def root_path
      return File.join(Dir.home, ".homer")
    end

    def token_path
      File.join(root_path, "token")
    end

    def get_generic_home_relative_path(filepath)
      filepath.gsub(/\/home\/[^\/]*\//, "~/")
    end

  end
end
