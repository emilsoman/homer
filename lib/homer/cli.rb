require 'homer/dotfiles'
require 'homer/github'

module Homer
  class CLI
    class << self

      def init
        raise Homer::HomerAlreadyInitialized, 'Homer already initialized'\
          if already_initialized?
        create_root_path
        #github_username, repo_name = Homer::Github.parse_address(gh_address)
        #setup_dotfiles
        #setup_user(github_username, repo_name)
      end

      def create(gh_address)
        assert_initialized!
        dotfiles = Dotfiles.new(gh_address).init
      end

      # Validate if dotfiles dir is valid
      # and set it as the default dotfiles
      def default(gh_address)
        assert_initialized!
        dotfiles = Dotfiles.new(gh_address).validate!
        set_config(:default, gh_address)
      end

      #def wipe
        ##puts "Should place your homerfiles where they actually belonged."
      #end

      #def add_dotfile(filename, home_relative_path)
        #user = current_user
        #user.add_dotfile(filename, home_relative_path)
      #end

      #def list
        #user = current_user
        #user.homerfile.load
        #rows = []
        #user.homerfile.dotfiles.each do |file, path|
          #rows << [file, path]
        #end
        #table = Terminal::Table.new :title => "Dotfiles of #{user.github_username}", :headings => ['Filename', 'Path'], :rows => rows
        #say ("<%= color('#{table}', :green) %>")
      #end

      #def sync
        #current_user.sync
      #end

      # Create root path if it doesn't exist,
      # Clone dotfiles from github if not cloned previously/
      # Pull updates from github if cloned previously,
      # Setup symlinks of a valid Homerfile exists,
      # Update +current_dotfiles+ config
      def use(gh_address)
        create_root_path
        Dotfiles.new(gh_address).use
        set_config(:current_dotfiles, gh_address)
      end

      #def bye
        ##Cleanup after saying bye to old user ?
        #user = User.new(get_config(:default_user))
        #user.use
      #end

      def root_path
        File.join(Dir.home, '.homer')
      end

      def create_root_path
        Dir.mkdir(root_path) unless Dir.exists?(root_path)
      end

      def config_path
        File.join(root_path, 'config.yml')
      end

      def set_config(key, value)
        if File.exists?(config_path)
          content = YAML.load_file(config_path)
          content[key] = value
        else
          content = {key => value}
        end
        File.open(config_path, 'w') do |f|
          YAML.dump(content, f)
        end
      end


      def get_config(key)
        config = YAML.load_file(config_path)
        return config[key]
      rescue
        return nil
      end

      def setup_user(github_username, repo_name)
        user = User.new(github_username)
        user.init(repo_name)
        user.use
        set_config(:default_user, github_username)
      end

      def current_user
        user = User.new(get_config(:current_user))
      end

      def already_initialized?
        Dir.exist?(root_path)
      end

      def assert_initialized!
        raise Homer::HomerNotInitialized, 'Homer not initialized'\
          unless already_initialized?
      end
    end
  end
end
