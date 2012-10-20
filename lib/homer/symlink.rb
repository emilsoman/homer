class SymLink

  #Returns all files in dotfiles_list
  def self.filenames
    symlinks = FileLayer.read_symlink_file
    symlinks.keys
  end

  def self.file_paths
    symlinks = FileLayer.read_symlink_file
    symlinks.keys
  end

  def self.filenames
    symlinks = FileLayer.read_symlink_file
    symlinks.values
  end

  #Adds file to dotfiles_list , moves the file to dotfiles folder 
  #and creates a symlink with original filepath 
  def self.add(dotfile)
    dotfile = File.expand_path(dotfile)
    raise "#{dotfile} does not exist." unless File.exists?(dotfile)
    filename = File.basename(dotfile)
    filename_to_store = get_unused_filename(filename, filenames)
    symlinks = FileLayer.read_symlink_file
    if symlinks.keys.include?(FileLayer.get_generic_home_relative_path(dotfile))
      puts "I am already tracking this file. Do you want to overwrite it ?"
      confirm = ask("y/n: ")
      return if confirm.downcase.include?("n")
    end
    symlinks[FileLayer.get_generic_home_relative_path(dotfile)] = filename_to_store
    FileLayer.save_symlink_file(symlinks)
    FileLayer.create_symlink(filename_to_store,dotfile)
  end

  private

    #Gets the next unused filename by adding an integer suffix to filename
    def self.get_unused_filename(filename, existing_filenames)
      filename_to_store = filename
      count = 1
      until !existing_filenames.include?(filename_to_store)
        filename_to_store = filename + "_" + count.to_s
        count += 1
      end
      return filename_to_store
    end

end
