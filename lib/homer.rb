require 'yaml'
require 'homer/version'
require 'homer/symlink'
require 'homer/homerfile'
require 'github_api'
require 'homer/github'
require 'homer/user'
require 'highline/import'
require 'terminal-table'

class Homer

  class << self

    def init
      github_username = ask("What's your GitHub username? ")
      if agree("Do you have a dotfiles repository on GitHub already? ")
        repo_name = ask("What's the repository's name? ")
      else
        repo_name = ask("Okay.We'll create a new repo then. Pick a name : ")
        github = GitHub.new(github_username)
        password = ask("GitHub password : ") { |q| q.echo = false }
        github.create_repo(password, repo_name)
      end
      setup_user(github_username, repo_name)
    end

    def wipe
      #puts "Should place your homerfiles where they actually belonged."
    end

    def add_dotfile(filename, home_relative_path)
      user = current_user
      user.add_dotfile(filename, home_relative_path)
    end

    def list
      user = current_user
      user.homerfile.load
      rows = []
      user.homerfile.dotfiles.each do |file, path|
        rows << [file, path]
      end
      table = Terminal::Table.new :title => "Dotfiles of #{user.github_username}", :headings => ['Filename', 'Path'], :rows => rows
      say ("<%= color('#{table}', :green) %>")
    end

    def sync
      current_user.sync
    end

    def hi(login, dotfiles_repo_name='dotfiles')
      user = User.new(login)
      user.save(dotfiles_repo_name) if !User.exists?(login)
      user.use
    end

    def bye
      #Cleanup after saying bye to old user ?
      user = User.new(get_config(:default_user))
      user.use
    end

    def root_path
      path = File.join(Dir.home, '.homer')
      Dir.mkdir(path) unless Dir.exists?(path)
      return path
    end

    def config_path
      return File.join(root_path, 'config.yml')
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

  end

end
