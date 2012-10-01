class SymLink

  def self.filenames
    symlinks = FileLayer.read_symlink_file
    symlinks.keys
  end

  def self.add(dotfile)
    dotfile = File.expand_path(dotfile)
    raise "#{dotfile} does not exist." unless File.exists?(dotfile)
    filename = File.basename(dotfile)
    filename_to_store = get_unused_filename(filename, filenames)
    symlinks = FileLayer.read_symlink_file
    symlinks[filename_to_store] = FileLayer.get_generic_home_relative_path(dotfile)
    FileLayer.save_symlink_file(symlinks)
    FileLayer.create_symlink(filename_to_store,dotfile)
  end

  private
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
