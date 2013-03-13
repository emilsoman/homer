require 'spec_helper'

describe Homer do
  describe ".init" do
    let(:username){ 'emilsoman' }
    let(:repo_name){ 'dotfiles' }
    let(:password) { 'topsecret' }
    context "when repository doesn't exist" do
      it "should create a repo and setup user" do
        Homer.should_receive(:ask).with("What's your GitHub username? ").and_return(username)
        Homer.should_receive(:agree).with("Do you have a dotfiles repository on GitHub already? ").and_return(false)
        Homer.should_receive(:ask).with("Okay.We'll create a new repo then. Pick a name : ").and_return(repo_name)
        Homer.should_receive(:ask).with("GitHub password : ").and_return(password)
        github = double('Github')
        GitHub.should_receive(:new).with(username, repo_name).and_return(github)
        github.should_receive(:create_repo).with(password)
        Homer.should_receive(:setup_user).with(username, repo_name)
        Homer.stub(:say)
        Homer.init
      end
    end

    context "when repository exists" do
      it "should just get the repo name and setup user" do
        Homer.should_receive(:ask).with("What's your GitHub username? ").and_return(username)
        Homer.should_receive(:agree).with("Do you have a dotfiles repository on GitHub already? ").and_return(true)
        Homer.should_receive(:ask).with("What's the repository's name? ").and_return(repo_name)
        Homer.should_receive(:setup_user).with(username, repo_name)
        Homer.stub(:say)
        Homer.init
      end
    end
  end

  describe ".root_path", fakefs: true do
    it "should return the absolute path to .homer" do
      expected_root_path = File.join(Dir.home, '.homer')
      Dir.exists?(expected_root_path).should be_false
      Homer.root_path.should == expected_root_path
      Dir.exists?(expected_root_path).should be_true
    end
  end

  describe ".config_path", fakefs: true do
    it "should return the absolute path to .homer/config.yml" do
      Homer.config_path.should == File.join(Homer.root_path, 'config.yml')
    end
  end

  describe ".setup_user" do
    it "should create new user" do
      username = 'emilsoman'
      repo_name = 'dotfiles'
      user = double('User')
      User.should_receive(:new).with(username, repo_name).and_return(user)
      user.should_receive(:init)
      user.should_receive(:use)
      Homer.setup_user(username, repo_name)
    end
  end

=begin
  describe ".add" do
    it "should call Symlink add" do
      Symlink.should_receive(:add).with('dotfile')
      Homer.add('dotfile')
    end
  end

  describe ".list" do
    it "should call Symlink file_paths" do
      Symlink.should_receive(:file_paths)
      Homer.list
    end
  end

  describe ".push" do
    it "should call GitHubLayer push with dotfiles directory" do
      FileLayer.should_receive(:dotfiles_directory_path).and_return('dotfiles_dir_path')
      GitHubLayer.should_receive(:push).with('dotfiles_dir_path')
      Homer.push
    end
  end

  describe ".hi" do
    it "should make room for login, use GitHubLayer to pull dotfiles and use the room" do
      Homer.stub(:puts)
      FileLayer.should_receive(:make_room).with('login').and_return('room')
      Dir.should_receive(:chdir).with('room')
      GitHubLayer.should_receive(:get_dotfiles).with('login')
      Homer.should_receive(:use).with('room')
      Homer.hi('login')
    end
  end

  describe ".use" do
    it "should say bye to current user, FileLayer should create current symlinks" do
      FileLayer.should_receive(:create_current_symlink).with('room')
      Homer.should_receive(:bye)
      Homer.use('room')
    end
  end

  describe ".bye" do
    it "should make FileLayer delete current symlinks and restore backups" do
      FileLayer.should_receive(:delete_current_symlinks)
      FileLayer.should_receive(:restore_backup)
      Homer.bye
    end
  end
=end

end
