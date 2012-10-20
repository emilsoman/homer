require 'fileutils'
require 'homer/symlink'
require 'yaml'

class FileLayer
  class << self

    #Creates the homer root directory if it does not exist already
    #Creates the dotfiles directory if it does not exist already
    #Creates a dotfiles list YML file if it does not exist already
    def prepare_homer_folder
      Dir.mkdir(root_path) unless Dir.exists?(root_path)
      Dir.mkdir(dotfiles_directory_path) unless Dir.exists?(dotfiles_directory_path)
      File.new(dotfiles_path , "w") unless File.exists?(dotfiles_path)
    rescue Exception => e
      raise "~/.homer cannot be created : #{e.message}"
    end

    #Deletes the homer root
    def delete_homer_folder
      FileUtils.rm_rf(root_path)
    end 

    #Reads and returns the contents of the dotfiles list YML file
    def read_symlink_file
      return {} if !File.exists?(dotfiles_path) or File.zero?(dotfiles_path)
      YAML.load_file(dotfiles_path)
    end

    #Writes contents to dotfiles list YML file
    def save_symlink_file(symlinks)
      File.open(dotfiles_path,"w") do |out|
        YAML.dump(symlinks,out)
      end
    end

    #Moves the file to dotfiles directory and creates a symlink at original location
    def create_symlink(filename,file_path)
      file_in_dotfiles_folder = File.join(dotfiles_directory_path, filename)
      FileUtils.mv(file_path, file_in_dotfiles_folder)
      File.symlink(file_in_dotfiles_folder, file_path)
    end

    #HOMER PATHS

    #This is the dotfiles list YML file .
    #This is where a mapping of files in dotfiles folder 
    #to actual location in filesystem exists
    def dotfiles_path
      return File.join(dotfiles_directory_path, "dotfiles_list.yml")
    end

    #This is the directory to which the dotfiles will be moved
    def dotfiles_directory_path
      return File.join(root_path, "dotfiles/")
    end

    #This is where homer
    def root_path
      return File.join(Dir.home, ".homer")
    end

    def get_generic_home_relative_path(filepath)
      filepath.gsub(/\/home\/[^\/]*\//, "~/")
    end

  end
end
