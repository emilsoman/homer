class User
  attr_accessor :directory, :homerfile, :dotfiles_directory

  def initialize(github_username)
    @github_username = github_username
    @directory = File.join(Homer.root_path, github_username)
    @dotfiles_directory = File.join(@directory, 'dotfiles')
    @homerfile = Homerfile.new(@dotfiles_directory)
    @github = GitHub.new(@github_username)
  end

  def init(repo_name)
    save(repo_name)
    @homerfile.init unless @homerfile.valid?
    sync
  end

  def save(repo_name)
    Dir.mkdir(@directory) unless Dir.exists?(@directory)
    Dir.chdir(@directory)
    @github.clone(repo_name, @dotfiles_directory)
  end

  def sync
    Dir.chdir(@dotfiles_directory)
    @github.sync
  end

  def use
    @homerfile.load
    @homerfile.dotfiles.each do |file, path|
      dotfile = File.join(@dotfiles_directory, file)
      Symlink.create(dotfile, path)
    end
    Homer.set_current_user(@github_username)
  end

  def add_dotfile(filename, home_relative_path)
    homerfile.add_dotfile(filename, home_relative_path)
    dotfile = File.join(@dotfiles_directory, filename)
    Symlink.create(dotfile, home_relative_path)
  end

end
