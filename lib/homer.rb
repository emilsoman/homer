require 'fileutils'

class Homer

  def self.init
    Dir.mkdir(File.join(Dir.home, ".homer"))
    File.new(dotfiles_path , "w")
  rescue Exception => e
    raise "~/.homer cannot be created : #{e.message}"
  end

  def self.dotfiles_path
    return File.join(Dir.home, ".homer", "dotfiles")
  end

  def self.root_path
    return File.join(Dir.home, ".homer")
  end

  def self.wipe
    FileUtils.rm_rf(File.join(Dir.home, ".homer"))
  end

  def self.add(dotfile)
    dotfile = File.expand_path(dotfile)
    f = File.open(dotfiles_path, "a")
    raise "#{dotfile} does not exist." unless File.exists?(dotfile)
    f.puts dotfile
    f.close
  end

  def self.list
    File.read(dotfiles_path)
  end

end

