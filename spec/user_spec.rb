require 'spec_helper'

describe User, fakefs: true do
  let(:username) { 'emilsoman' }
  let(:repo_name) { 'dotfiles' }

  before(:each) do
    Dir.exists?(File.join(Dir.home, '.homer')).should be_false
  end

  describe ".new" do
    let(:user) { User.new(username) }
    it "should set user directory path on directory attribute" do
      user.directory.should == File.join(Dir.home, '.homer', username)
    end
  end

  describe "#init" do
    context 'when user has a valid Homerfile' do
      it "should not invoke homerfile.init" do
        homerfile = double('Homerfile')
        homerfile.should_receive(:valid?).and_return true
        homerfile.should_not_receive :init
        Homerfile.should_receive(:new).with(File.join(Homer.root_path, username, repo_name)).and_return(homerfile)
        user = User.new(username)
        user.should_receive :save
        user.should_receive :sync
        user.init(repo_name)
      end
    end
    context 'when user does not have a valid Homerfile' do
      it "should invoke homerfile.init" do
        homerfile = double('Homerfile')
        homerfile.should_receive(:valid?).and_return false
        homerfile.should_receive :init
        Homerfile.should_receive(:new).with(File.join(Homer.root_path, username, repo_name)).and_return(homerfile)
        user = User.new(username)
        user.should_receive :save
        user.should_receive :sync
        user.init(repo_name)
      end
    end
  end

  describe "#save" do
    let(:github){ double('GitHub').as_null_object}
    it "should create user directory" do
      github.should_receive(:clone).with(repo_name, File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username)
      Dir.exists?(user.directory).should be_false
      user.save(repo_name)
      Dir.exists?(user.directory).should be_true
    end
    it "should clone dotfiles repo" do
      github.should_receive(:clone).with(repo_name, File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username)
      user.save(repo_name)
    end
  end

  describe "#sync" do
    let(:github){ double('GitHub').as_null_object}
    it "should invoke github.sync" do
      github.should_receive(:sync)
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username)
      FileUtils.mkdir_p(File.join(user.directory, repo_name))
      user.sync
      Dir.pwd.should == File.join(user.directory, repo_name)
    end
  end

  describe "#use" do
    let(:user){ User.new(username)  }
    let(:github){ double('GitHub').as_null_object}
    before(:each) do
      github.should_receive(:clone).with(repo_name, File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.stub(:new).and_return(github)
      user.save(repo_name)
      FileUtils.mkdir_p(File.join(Dir.home, 'test'))
      FileUtils.mkdir_p(File.join(user.directory, repo_name))
      File.new(File.join(Dir.home, '.dotfile1'), 'w')
      File.new(File.join(Dir.home, 'test', '.dotfile2'), 'w')
      user.homerfile.add_dotfile('dotfile1', '~/.dotfile1')
      user.homerfile.add_dotfile('dotfile2', '~/test/.dotfile2')
    end
    it "should create symlinks from Homerfile entries" do
      user.use
      symlink1 = File.join(Dir.home, '.dotfile1')
      symlink2 = File.join(Dir.home, 'test', '.dotfile2')
      File.symlink?(symlink1).should be_true
      File.readlink(symlink1).should == File.join(user.directory, repo_name, 'dotfile1')
      File.readlink(symlink2).should == File.join(user.directory, repo_name, 'dotfile2')
    end
    context "when homerfile is invalid" do
      it "should raise exception" do
        user.homerfile.should_receive(:validate!).and_raise "invalid homerfile"
        expect{user.use}.to raise_error "invalid homerfile"
      end
    end
  end

  describe "#add_dotfile" do
    let(:dotfile_path) {File.join(Dir.home, 'test', '.dotfile')}
    let(:filename) {'file'}
    let(:dotfile_content) {'Oh njan vicharichu etho kuthaka muthalali ayirikum ennu'}
    let(:user) { User.new('emilsoman')  }
    before(:each) do
      FileUtils.mkdir_p(File.join(Dir.home, 'test'))
      FileUtils.mkdir_p(user.directory)
      File.open(dotfile_path, 'w') do |f|
        f << dotfile_content
      end
      filesize = File.size(dotfile_path)
      user.add_dotfile(filename, '~/test/.dotfile')
    end
    it "should move file to homerfile" do
      File.size(File.join(user.dotfiles_directory,filename)).should == dotfile_content.size
    end
    it "should create a symlink at original dotfile path" do
      File.symlink?(dotfile_path).should be_true
    end
    it "should link the symlink to file in user directory in homer" do
      File.readlink(dotfile_path).should == File.join(user.dotfiles_directory,filename)
    end
  end

  describe ".exists?" do
    let(:user) { User.new(username) }
    context "when user directory exists" do
      it "should return true" do
        FileUtils.mkdir_p(user.directory)
        User.exists?(username).should be_true
      end
    end
    context "when user directory does't exist" do
      it "should return false" do
        User.exists?('rosemary').should be_false
      end
    end
  end

  describe ".delete" do
    let(:user) { User.new(username) }
    context "when user directory exists" do
      it "should delete user directory" do
        FileUtils.mkdir_p(user.directory)
        User.exists?(username).should be_true
        User.delete(username)
        User.exists?(username).should be_false
      end
    end
    context "when user directory does't exist" do
      it "should do nothing" do
        User.exists?('rosemary').should be_false
        expect{User.delete('rosemary')}.not_to raise_error
      end
    end
  end

end
