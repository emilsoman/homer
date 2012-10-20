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

    #Creates the homer root directory if it does not exist already
    #Creates the dotfiles directory if it does not exist already
    def init
      Dir.mkdir(root_path) unless Dir.exists?(root_path)
      Dir.mkdir(dotfiles_directory_path) unless Dir.exists?(dotfiles_directory_path)
    rescue Exception => e
      raise "~/.homer cannot be created : #{e.message}"
    end

    #Makes a directory for the given GitHub login
    def make_room(login)
      FileUtils.mkdir_p(room_path(login)) unless Dir.exists?(room_path(login))
      return room_path(login)
    rescue Exception => e
      raise "~/.homer cannot be created : #{e.message}"
    end

    #Deletes the homer root
    def delete_homer_folder
      FileUtils.rm_rf(root_path)
    end 
    #Reads and returns the contents of the dotfiles list YML file
    def read_symlink_file
      read_yml_file(dotfiles_path)
    end

    #Reads and returns the contents of the backup_list YML file
    def read_backup_list
      read_yml_file(backup_list_path)
    end

    #Writes contents to dotfiles list YML file
    def save_symlink_file(symlinks)
      save_yml_contents(dotfiles_path, symlinks)
    end

    #Writes contents to backup list YML file
    def save_backup_list(backup_details)
      save_yml_contents(backup_list_path, backup_details)
    end

    #Reads and returns the contents of YML file
    def read_yml_file(path)
      return {} if !File.exists?(path) or File.zero?(path)
      YAML.load_file(path)
    end

    #Writes contents to YML file
    def save_yml_contents(yml_file_path, contents)
      File.open(yml_file_path,"w") do |out|
        YAML.dump(contents,out)
      end
    end

    #Moves the file to dotfiles directory and creates a symlink at original location
    def create_symlink(filename,file_path)
      file_in_dotfiles_folder = File.join(dotfiles_directory_path, filename)
      FileUtils.mv(file_path, file_in_dotfiles_folder)
      File.symlink(file_in_dotfiles_folder, file_path)
    end

    #Deletes symlinks created for current room
    def delete_current_symlinks
      return if !File.exists?(current_room_path)
      symlinks = read_yml_file(current_room_dotfiles_path).values
      symlinks.each do |symlink|
        symlink_path = File.expand_path(symlink)
        File.unlink(symlink_path)
      end
      File.unlink(current_room_path) 
    end

    #Create 'current' symlink for a room
    def create_current_symlink(room)
      File.symlink(room, current_room_path)
      symlinks = read_yml_file(current_room_dotfiles_path)
      symlinks.each do |file, symlink|
        add_backup(File.expand_path(symlink))
	require 'debugger'
	debugger
        File.symlink(File.join(current_room_path, file), File.expand_path(symlink))
      end
    end

=begin
    #Deletes file if symlink , else moves to backup
    def backup(file)
      if File.symlink?(symlink_path)
        File.unlink(symlink_path)
      else 
        add_backup(symlink_path)
      end
    end
=end

    #Moves file to backup_dir
    def add_backup(file_path)
      FileUtils.mkdir_p(backup_path) unless File.exists?(backup_path)
      backup_file_path = File.join(backup_path, File.basename(file_path))
      backup_file_path = File.exists?(backup_file_path) ? backup_file_path + Time.now.to_i.to_s : backup_file_path
      backup_list = read_backup_list
      if File.symlink?(file_path)
        backup_list[backup_file_path] = {target_path: File.readlink(file_path), link_path: file_path }
      else
        backup_list[backup_file_path] = {target_path: file_path}
      end
      FileUtils.mv(file_path, backup_file_path)
      save_backup_list(backup_list)
    end

    #Restores the files stored in backup_path
    def restore_backup
      backup_list = read_backup_list
      backup_list.each do |file, file_details|
        file_path_in_backup_folder = File.join(backup_path, file)
        if file_details[:is_symlink]
          File.unlink(file_details[:link_path])
          File.symlink(file_details[:target_path], file_details[:link_path])
        else
          FileUtils.mv(file_path_in_backup_folder, file_details[:target_path])
        end
      end
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

    #This is where homer lives
    def root_path
      return File.join(Dir.home, ".homer")
    end

    #This is where the dotfiles of a GitHub user is pulled
    def room_path(login)
      return File.join(root_path, 'room', login)
    end

    #This is the currently used room
    def current_room_path
      return File.join(root_path, 'current')
    end

    #This is the dotfiles list for currently used room
    def current_room_dotfiles_path
      return File.join(current_room_path, 'dotfiles', 'dotfiles_list.yml')
    end

    #This is where homer keeps the backups
    def backup_path
      return File.join(root_path, 'backup')
    end

    #This is the path to backup_list YML file which has the details of backed up files
    def backup_list_path
      return File.join(backup_path, 'backup_list.yml')
    end

    def get_generic_home_relative_path(filepath)
      filepath.gsub(/\/home\/[^\/]*\//, "~/")
    end

  end
end
