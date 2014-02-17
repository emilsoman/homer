require 'homer/cli'
require 'homer/github'
require 'homer/homerfile'
require 'homer/symlink'
require 'fileutils'

module Homer
  class Dotfiles

    attr_reader :directory, :homerfile

    def initialize(gh_address)
      @directory = File.join(CLI.root_path, gh_address)
      @homerfile = Homerfile.new(@directory)
      @github = Github.new(gh_address)
    end

    def use
      clone_or_update
      setup_symlinks
    end

    def init
      
    end

    def path(dotfile)
      File.join(@directory, dotfile)
    end

    def validate!
      @homerfile.validate_and_load!
    end

    private

      def exist?
        Dir.exist?(@directory)
      end

      def clone_or_update
        if exist?
          Dir.chdir(@directory) do
            @github.update
          end
        else
          FileUtils.mkdir_p(@directory)
          @github.clone(@directory)
        end
      end

      def setup_symlinks
        @homerfile.validate_and_load!
        @homerfile.dotfiles.each do |file, path|
          dotfile = File.join(@directory, file)
          Symlink.create(dotfile, path)
        end
      end
  end
end
