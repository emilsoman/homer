require 'spec_helper'

describe User, fakefs: true do
  let(:username) { 'emilsoman' }
  let(:repo_name) { 'dotfiles' }

  before(:each) do
    Dir.exists?(File.join(Dir.home, '.homer')).should be_false
  end

  describe ".new" do
    let(:user) { User.new(username, repo_name) }
    it "should set user directory path on directory attribute" do
      user = User.new(username, repo_name)
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
        user = User.new(username, repo_name)
        user.should_receive :save
        user.should_receive :sync
        user.init
      end
    end
    context 'when user does not have a valid Homerfile' do
      it "should invoke homerfile.init" do
        homerfile = double('Homerfile')
        homerfile.should_receive(:valid?).and_return false
        homerfile.should_receive :init
        Homerfile.should_receive(:new).with(File.join(Homer.root_path, username, repo_name)).and_return(homerfile)
        user = User.new(username, repo_name)
        user.should_receive :save
        user.should_receive :sync
        user.init
      end
    end
  end

  describe "#save" do
    let(:github){ double('GitHub').as_null_object}
    it "should create user directory" do
      github.should_receive(:clone).with(File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username, repo_name)
      Dir.exists?(user.directory).should be_false
      user.save
      Dir.exists?(user.directory).should be_true
    end
    it "should clone dotfiles repo" do
      github.should_receive(:clone).with(File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username, repo_name)
      user.save
    end
  end

  describe "#sync" do
    let(:github){ double('GitHub').as_null_object}
    it "should invoke github.sync" do
      github.should_receive(:sync)
      GitHub.should_receive(:new).and_return(github)
      user = User.new(username, repo_name)
      FileUtils.mkdir_p(File.join(user.directory, repo_name))
      user.sync
      Dir.pwd.should == File.join(user.directory, repo_name)
    end
  end

  describe "#use" do
    let(:user){ User.new(username, repo_name)  }
    let(:github){ double('GitHub').as_null_object}
    before(:each) do
      github.should_receive(:clone).with(File.join(Homer.root_path, username, 'dotfiles'))
      GitHub.stub(:new).and_return(github)
      user.save
      FileUtils.mkdir_p(File.join(user.directory, repo_name))
      File.new(File.join(user.directory, repo_name, 'Homerfile'), 'w')
      File.new(File.join(user.directory, repo_name, 'dotfile1'), 'w')
      File.new(File.join(user.directory, repo_name, 'dotfile2'), 'w')
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
  end

end
