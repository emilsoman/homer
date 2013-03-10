class GitHub
  attr_accessor :repo
  def initialize(github_username, repo_name)
    @username = github_username
    @repo_name = repo_name
    @repo = "git@github.com:#{github_username}/#{repo_name}.git"
  end

  def create_repo(password)
    github = Github.new(login: @username, password: password)
    begin
      github.repos.create(name: @repo_name)
    rescue Github::Error::UnprocessableEntity
      puts "Repository - '#{@repo_name}' already exists under '#{@username}', we'll see if we can use that."
    end
  end

  def clone(clone_directory)
    system("git clone --quiet #{repo} #{clone_directory}")
  end

  def sync
    system("git add --all")
    system("git commit -m 'Updated dotfiles'")
    system("git pull")
    system("git push origin master")
  end

end
