require 'yaml'
require 'homer/symlink'
require 'homer/homerfile'
require 'github_api'
require 'homer/github'
require 'homer/user'

class Homer

  class << self

    def init
      github_username = ask("What's your GitHub username? ")
      if agree("Do you have a dotfiles repository on GitHub already? ")
        repo_name = ask("What's the repository's name? ")
      else
        repo_name = ask("Okay.We'll create a new repo then. Pick a name : ")
        github = GitHub.new(github_username, repo_name)
        password = ask("GitHub password : ") { |q| q.echo = false }
        github.create_repo(password)
      end
      setup_user(github_username, repo_name)
      #FileLayer.init
      #GitHubLayer.init(FileLayer.dotfiles_directory_path)
    end

    def wipe
      puts "Real functionality is too dangerous to be a release candidate for now . ;)"
      #FileLayer.delete_homer_folder
    end

    def add(dotfile)
      #FileLayer.prepare_homer_folder
      puts "To be implemented"
      return
      SymLink.add(dotfile)
    end

    def list
      puts "To be implemented"
      return
      SymLink.file_paths
    end

    def push
      puts "To be implemented"
      return
      dotfiles_dir = FileLayer.dotfiles_directory_path
      GitHubLayer.push(dotfiles_dir)
    end

    def hi(login)
      puts "To be implemented"
      return
      puts "Hi #{login}"
      room = FileLayer.make_room(login)
      puts "Your room is here : #{room}"
      Dir.chdir(room)
      puts "Getting all your dotfiles"
      GitHubLayer.get_dotfiles(login)
      puts "Getting your room ready"
      use(room)
      puts "Done! Be at home , #{login}"
    end

    def use(room)
      puts "To be implemented"
      return
      bye
      FileLayer.create_current_symlink(room)
    end

    def bye
      puts "To be implemented"
      return
      FileLayer.delete_current_symlinks
      FileLayer.restore_backup
    end

    def root_path
      path = File.join(Dir.home, '.homer')
      Dir.mkdir(path) unless Dir.exists?(path)
      return path
    end

    def config_path
      return File.join(root_path, 'config.yml')
    end

    def set_current_user(username)
      content = {current_user: username}
      if File.exists?(config_path)
        content = YAML.load_file(config_path)
        content[:current_user] = username
      end
      File.open(config_path, 'w') do |f|
        YAML.dump(content, f)
      end
    end

    def current_user
      config = YAML.load_file(config_path)
      return config[:current_user]
    end

    def setup_user(github_username, repo_name)
      user = User.new(github_username, repo_name)
      user.init
      user.use
    end

  end

end
