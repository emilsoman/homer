require 'homer/errors'

module Homer
  class Homerfile
    attr_accessor :dotfiles, :error, :path

    def initialize(dotfiles_directory)
      @path = File.join(dotfiles_directory, 'Homerfile')
      @dotfiles = {}
    end

    def init
      return if File.exists?(@path)
      File.new(@path, "w")
      #say "========================================================="
      #say "\nWe'll add some dotfiles to #{@path} and get you started\n"\
            #"Example: To start tracking /home/username/.bash_aliases, enter the following details -\n"\
            #"\t<%= color('Filename: bash_aliases', :yellow) %>\n"\
            #"\t<%= color('Home relative path: ~/.bash_aliases', :yellow) %>\n"\
            #"Alright. Let's do this.\n\n"
      #say "========================================================="
      #begin
        #filename = ask("Filename: ")
        #filepath = ask("Home relative path: ")
        #begin
          #add_dotfile(filename, filepath)
        #rescue Exception => e
          #say("<%= color('#{filepath} can\\'t be tracked. Make sure it exists and it\\'s not a symlink.', :red) %>")
        #end
      #end while agree("Add another dotfile?")
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

    def validate_and_load!
      raise Homer::HomerfileNotFound, "No Homerfile found at #{@path}" if !File.exists?(@path)
      raise Homer::HomerfileEmpty, "Empty Homerfile at #{@path}" if File.zero?(@path)
      load
      unless @dotfiles.is_a? Hash
        raise Homer::HomerfileCorrupt, "Homerfile is corrupted. I'm expecting a hash in there"
      end
    end

    def add_dotfile(filename, file_path)
      load
      @dotfiles ||= {}
      raise "File appears to be a symlink. Can't add a symlink." if File.symlink?(File.expand_path(file_path))
      FileUtils.mv(File.expand_path(file_path), File.join(File.dirname(@path), filename))
      @dotfiles[filename] = file_path
      save
    end

    def create_symlinks
      @dotfiles.each do |file, path|
        dotfile = File.join(@dotfiles_directory, file)
        Symlink.create(dotfile, path)
      end
    end

    def save
      #return if !@dotfiles.is_a?(Hash)
      File.open(@path, 'w') do |f|
        YAML.dump(@dotfiles, f)
      end
    end
  end
end
