class GitHub
  attr_accessor
  def initialize(github_username)
    @username = github_username
  end

  def create_repo(password, repo_name)
    github = Github.new(login: @username, password: password)
    begin
      github.repos.create(name: repo_name)
    rescue Github::Error::GithubError
      say "<%= color('Repository - #{repo_name} already exists under #{@username}, we will see if we can use that.', :yellow) %>"
    end
  end

  def clone(repo_name="dotfiles", clone_directory="dotfiles")
    readonly_repo_url = "git://github.com/#{@username}/#{repo_name}.git"
    set_remote_url_cmd = "git remote set-url --push origin git@github.com:#{@username}/#{repo_name}.git"
    system("git clone --quiet #{readonly_repo_url} #{clone_directory}")
    system(set_remote_url_cmd)
  end

  def sync
    system("git add --all")
    system("git commit -m 'Updated dotfiles'")
    system("git pull")
    system("git push origin master")
  end

end
