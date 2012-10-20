require 'github_api'
require 'homer/file_layer'
require 'highline/import'

class GitHubLayer
  REPO_NAME = 'dotfiles'
  class << self

    def init(directory)
      create_repo_if_repo_does_not_exist(directory)
      %x{git pull origin master}
    end

    def push(directory)
      create_repo_if_repo_does_not_exist(directory)
      %x{git add .}
      %x{git commit -m "Homer push"}
      %x{git pull origin master}
      %x{git push origin master}
    end

    def create_repo_if_repo_does_not_exist(directory)
      Dir.chdir(directory)
      return if origin_added_as_remote?
      puts "I need your GitHub login to create a '#{REPO_NAME}' repo if it doesn't exist already"
      login = ask("Login: ")
      password = ask("Password: ") { |q| q.echo = false } 
      puts "Connecting to GitHub. Please Wait"
      github = Github.new(login: login, password: password)
      begin
        github.repos.get(github.login, REPO_NAME)
      rescue Github::Error::NotFound
        github.repos.create(name: REPO_NAME)
      end
      %x{git init .}
      %x{git remote add origin git@github.com:#{login}/#{REPO_NAME}.git}
    end

    def get_dotfiles(login)
      if !system("git clone git@github.com:#{login}/#{REPO_NAME}.git 2> /dev/null")
        %x{git pull origin master 2> /dev/null}
      end
    end

    def origin_added_as_remote?
      remotes = %x{git remote -v 2> /dev/null}
      return remotes.include?("origin\t")
    end

  end
end
