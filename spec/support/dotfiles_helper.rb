require 'homer/dotfiles'
require 'yaml'

module DotfilesHelper
  def setup_dotfiles(gh_address)
    #Create dotfiles directory
    dotfiles = Homer::Dotfiles.new(gh_address)
    FileUtils.mkdir_p(dotfiles.directory)
    #Create sample files
    Dir.chdir(dotfiles.directory) do
      File.open('vimrc', 'w')
      Dir.mkdir('vim')
    end
    #Create Homerfile
    homerfile_contents = {
      'vimrc' => '~/.vimrc',
      'vim'   => '~/.vim'
    }
    File.open(dotfiles.homerfile.path, 'w') do |file|
      file.puts homerfile_contents.to_yaml
    end
  end

  def dotfiles_should_be_symlinked_to(gh_address)
    dotfiles = Homer::Dotfiles.new(gh_address)
    expect(File.symlink?(File.expand_path '~/.vim')).to be_true
    expect(File.readlink(File.expand_path '~/.vim')).to eql dotfiles.path('vim')

    expect(File.symlink?(File.expand_path '~/.vimrc')).to be_true
    expect(File.readlink(File.expand_path '~/.vimrc')).to eql dotfiles.path('vimrc')
  end
end
