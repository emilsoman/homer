class Homerfile
  attr_accessor :dotfiles, :error
  def initialize(dotfiles_directory)
    @path = File.join(dotfiles_directory, 'Homerfile')
  end

  def init
    puts "We'll add some dotfiles to #{@path} and get you started\n"
          + "Example: To start tracking /home/username/.bash_aliases, enter the following details -\n"
          + "\tFilename: bash_aliases\n"
          + "\tHome relative path: ~/.bash_aliases\n"
          + "Alright. Let's do this."
    begin
      filename = ask("Filename: ")
      filepath = ask("Home relative path: ~/")
      filepath = "~/" + filepath
      add_dotfile(filename, filepath)
    end while agree("Add another dotfile?")
  end

  def load
    @dotfiles = YAML.load_file(@path)
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
    @dotfiles[filename] = file_path
    save
  end

  def save
    File.open(@path, 'w') do |f|
      YAML.dump(@dotfiles, f)
    end
  end

end
