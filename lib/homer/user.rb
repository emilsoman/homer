require 'homer/cli'
require 'homer/github'
require 'homer/homerfile'

module Homer
  class User
    attr_accessor :directory, :homerfile, :dotfiles_directory, :github_username

    def initialize(github_username, repo_name)
      @directory = File.join(Homer.root_path, github_username)
      @dotfiles_directory = File.join(@directory, repo_name)
      @homerfile = Homerfile.new(@dotfiles_directory)
      @github = GitHub.new(github_username, repo_name)
    end

    def github_username
      @github.username
    end

    def init(repo_name)
      save(repo_name)
      @homerfile.init
      #sync
    end

    def save(repo_name)
      Dir.mkdir(@directory) unless Dir.exists?(@directory)
      Dir.chdir(@directory) do
        unless @github.clone(@dotfiles_directory)
          Dir.mkdir(@dotfiles_directory) unless Dir.exists?(@dotfiles_directory)
        end
      end
    end

    #def sync
      #Dir.chdir(@dotfiles_directory)
      #@github.sync
    #end

    def use
      @homerfile.validate_and_load!
      @homerfile.dotfiles.each do |file, path|
        dotfile = File.join(@dotfiles_directory, file)
        Symlink.create(dotfile, path)
      end
      CLI.set_config(:current_user, @github_username)
    end

    def add_dotfile(filename, home_relative_path)
      homerfile.add_dotfile(filename, home_relative_path)
      dotfile = File.join(@dotfiles_directory, filename)
      Symlink.create(dotfile, home_relative_path)
    end

    def self.exists?(username)
      user = User.new(username, )
      Dir.exists?(user.directory) ? true : false
    end

    def self.delete(username)
      # TODO User shouldn't delete current_user
      # If user deletes default_user, set
      # current_user as default ?
      user = User.new(username)
      return if !User.exists?(username)
      FileUtils.rm_rf(user.directory)
    end

  end
end
