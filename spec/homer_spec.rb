require 'spec_helper'

describe Homer do
  describe ".init" do
    it "should call FileLayer and GitHubLayer init" do
      FileLayer.should_receive(:init).with no_args
      FileLayer.stub(:dotfiles_directory_path).and_return('dotfiles_directory_path')
      GitHubLayer.should_receive(:init).with('dotfiles_directory_path')
      Homer.init
    end
  end

  describe ".add" do
    it "should call Symlink add" do
      SymLink.should_receive(:add).with('dotfile')
      Homer.add('dotfile')
    end
  end

  describe ".list" do
    it "should call SymLink file_paths" do
      SymLink.should_receive(:file_paths)
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

end
