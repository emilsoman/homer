class Homerfile
  attr_accessor :dotfiles, :error, :path
  def initialize(dotfiles_directory)
    @path = File.join(dotfiles_directory, 'Homerfile')
  end

  def init
    return if File.exists?(@path)
    File.new(@path, "w")
    say "========================================================="
    say "\nWe'll add some dotfiles to #{@path} and get you started\n"\
          "Example: To start tracking /home/username/.bash_aliases, enter the following details -\n"\
          "\t<%= color('Filename: bash_aliases', :yellow) %>\n"\
          "\t<%= color('Home relative path: ~/.bash_aliases', :yellow) %>\n"\
          "Alright. Let's do this.\n\n"
    say "========================================================="
    begin
      filename = ask("Filename: ")
      filepath = ask("Home relative path: ")
      add_dotfile(filename, filepath)
    end while agree("Add another dotfile?")
  end

  def load
    @dotfiles = File.zero?(@path) ? {} : YAML.load_file(@path)
  rescue
    @dotfiles = {}
  end

  def valid?
    validate!
    @error = ""
    return true
  rescue Exception => e
    @error = e.message
    return false
  end

  def validate!
    raise "No Homerfile found at #{@path}" if !File.exists?(@path)
    raise "Empty Homerfile at #{@path}" if File.zero?(@path)
    load
    raise "Homerfile is corrupted. I'm expecting a hash in there" unless @dotfiles.is_a? Hash
  end

  def add_dotfile(filename, file_path)
    load
    @dotfiles ||= {}
    begin
      FileUtils.mv(File.expand_path(file_path), File.join(File.dirname(@path), filename))
      @dotfiles[filename] = file_path
      save
    rescue Exception => e
      say("<%= color('#{file_path} can\\'t tracked. Make sure it exists and it\\'s not a symlink.', :red) %>")
    end
  end

  def save
    return if !@dotfiles.is_a?(Hash)
    File.open(@path, 'w') do |f|
      YAML.dump(@dotfiles, f)
    end
  end

end
