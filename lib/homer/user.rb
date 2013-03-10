class User
  attr_accessor :directory, :homerfile

  def initialize(github_username, dotfiles_repo_name)
    @github_username = github_username
    @directory = File.join(Homer.root_path, github_username)
    @dotfiles_repo_name = dotfiles_repo_name
    @dotfiles_directory = File.join(@directory, 'dotfiles')
    @homerfile = Homerfile.new(File.join(@directory, dotfiles_repo_name))
    @github = GitHub.new(@github_username, @dotfiles_repo_name)
  end

  def init
    save
    @homerfile.init unless @homerfile.valid?
    sync
  end

  def save
    Dir.mkdir(@directory) unless Dir.exists?(@directory)
    Dir.chdir(@directory)
    @github.clone(@dotfiles_directory)
  end

  def sync
    Dir.chdir(@dotfiles_directory)
    @github.sync
  end

  def use
    @homerfile.load
    @homerfile.dotfiles.each do |file, path|
      dotfile = File.join(@dotfiles_directory, file)
      SymLink.create(dotfile, path)
    end
    Homer.set_current_user(@github_username)
  end

end
