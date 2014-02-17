require 'spec_helper'
require 'homer/cli'

describe Homer::CLI, fakefs: true do

  #describe ".init" do
    #context "when already initialized" do
      #it "should raise AlreadyInitialized error" do
        #Homer::CLI.init('test/test')
        #expect{Homer::CLI.init('test/test')}
          #.to raise_error(Homer::AlreadyInitialized)
      #end
    #end
    #it "should create" do
      
    #end
  #end

  describe ".set_config" do
    before { Homer::CLI.create_root_path  }
    context "when config file doesn't exist" do
      it "should create the config file with new config" do
        expect(File.exist?(Homer::CLI.config_path)).to be_false
        Homer::CLI.set_config(:hello, 'world')
        expect(File.exist?(Homer::CLI.config_path)).to be_true
        expect(Homer::CLI.get_config(:hello)).to eql('world')
      end
    end

    context "when config file exists" do
      it "should add the config to the existing file" do
        Homer::CLI.set_config(:key1, 'value1')
        Homer::CLI.set_config(:key2, 'value2')
        expect(Homer::CLI.get_config(:key1)).to eql('value1')
        expect(Homer::CLI.get_config(:key2)).to eql('value2')
      end
    end

    context "when config key exists" do
      it "should update the config value" do
        Homer::CLI.set_config(:key1, 'value1')
        Homer::CLI.set_config(:key1, 'value2')
        expect(Homer::CLI.get_config(:key1)).to eql('value2')
      end
    end
  end

  describe ".get_config" do
    context "when file doesn't exist" do
      it "should return nil" do
        expect(File.exist?(Homer::CLI.config_path)).to be_false
        expect(Homer::CLI.get_config(:hello)).to be_nil
      end
    end

    context "when file exists" do
      before do
        Homer::CLI.create_root_path
        File.open(Homer::CLI.config_path, 'w') do |f|
          YAML.dump({hello: 'world'}, f)
        end
      end
      it "should return the value of config key" do
        expect(Homer::CLI.get_config(:hello)).to eql('world')
      end

    end
  end


  describe ".use" do
    let(:gh_address) { 'emilsoman/dotfiles' }
    context "when dotfiles don't exist" do
      it "should clone dotfiles from github and setup symlinks" do
        Homer::Github.any_instance
          .should_receive(:clone)
          .with(File.join(Homer::CLI.root_path, gh_address))
        Homer::Dotfiles.any_instance.should_receive(:setup_symlinks)
        Homer::CLI.use(gh_address)
        expect(Homer::CLI.get_config(:current_dotfiles)).to eql(gh_address)
      end
    end
    context "when dotfiles exist" do
      include DotfilesHelper
      before do
        setup_dotfiles(gh_address)
      end
      it "should update dotfiles from github and setup symlinks" do
        Homer::Github.any_instance
          .should_receive(:update)
        Homer::Dotfiles.any_instance.should_receive(:setup_symlinks)
        Homer::CLI.use(gh_address)
        expect(Homer::CLI.get_config(:current_dotfiles)).to eql(gh_address)
      end
    end
  end

  #describe ".root_path" do
    #it "should return the absolute path to .homer" do
      #expected_root_path = File.join(Dir.home, '.homer')
      #Dir.exists?(expected_root_path).should be_false
      #Homer.root_path.should == expected_root_path
      #Dir.exists?(expected_root_path).should be_true
    #end
  #end

  #describe ".config_path" do
    #it "should return the absolute path to .homer/config.yml" do
      #Homer.config_path.should == File.join(Homer.root_path, 'config.yml')
    #end
  #end

  #describe "config stuff" do
    #before(:each) do
      #Homer.set_config(:default_user, 'defunkt')
      #Homer.set_config(:current_user, 'emilsoman')
    #end
    #describe ".get_config" do
      #it "should return the value of config attribute in .homer/config.yml" do
        #Homer.get_config(:current_user).should == 'emilsoman'
        #Homer.get_config(:default_user).should == 'defunkt'
      #end
      #context "when config file doesn't exist" do
        #it "should return nil" do
          #File.delete(Homer.config_path)
          #Homer.get_config(:current_user).should be_nil
          #Homer.get_config(:default_user).should be_nil
        #end
      #end
      #context "when config attribute doesn't exist" do
        #it "should return nil" do
          #Homer.get_config(:non_existent_key).should be_nil
        #end
      #end
    #end
  #end

  #describe ".setup_user" do
    #it "should create new user" do
      #username = 'emilsoman'
      #repo_name = 'dotfiles'
      #user = double('User')
      #User.should_receive(:new).with(username).and_return(user)
      #user.should_receive(:init).with(repo_name)
      #user.should_receive(:use)
      #Homer.should_receive(:set_config).with(:default_user, username)
      #Homer.setup_user(username, repo_name)
    #end
  #end

  #describe ".add_dotfile" do
    #let(:dotfile_path) {File.join(Dir.home, 'test', '.dotfile')}
    #let(:filename) {'file'}
    #let(:username) {'emilsoman'}
    #let(:dotfile_content) {'Oh njan vicharichu etho kuthaka muthalali ayirikum ennu'}
    #let(:user) { User.new(username)  }
    #before(:each) do
      #FileUtils.mkdir_p(File.join(Dir.home, 'test'))
      #FileUtils.mkdir_p(user.directory)
      #Homer.set_config(:current_user, username)
      #File.open(dotfile_path, 'w') do |f|
        #f << dotfile_content
      #end
      #filesize = File.size(dotfile_path)
      #Homer.add_dotfile(filename, '~/test/.dotfile')
    #end
    #it "should move file to homerfile" do
      #File.size(File.join(user.dotfiles_directory,filename)).should == dotfile_content.size
    #end
    #it "should create a symlink at original dotfile path" do
      #File.symlink?(dotfile_path).should be_true
    #end
    #it "should link the symlink to file in user directory in homer" do
      #File.readlink(dotfile_path).should == File.join(user.dotfiles_directory,filename)
    #end
  #end

  #describe ".list" do
    #let(:user) {User.new('emilsoman')}
    #before(:each) do
      #FileUtils.mkdir_p(user.dotfiles_directory)
      #Homer.set_config(:current_user, 'emilsoman')
      #user.homerfile.dotfiles = {'file' => 'path', 'file2' => 'path2'}
      #user.homerfile.save
    #end
    #it "should display a table containing all tracked files" do
      #table = double('Table')
      #Terminal::Table.should_receive(:new)
        #.with({
          #:title => "Dotfiles of emilsoman",
          #:headings => ['Filename', 'Path'],
          #:rows => [['file', 'path'],['file2', 'path2']]
        #}).and_return(table)
      #Homer.should_receive(:say).with("<%= color('#{table}', :green) %>")
      #Homer.list
    #end
  #end

  #describe ".sync" do
    #it "should invoke current_user#sync" do
      #Homer.set_config(:current_user, 'emilsoman')
      #user = double('User')
      #user.should_receive(:sync)
      #User.should_receive(:new).with('emilsoman').and_return(user)
      #Homer.sync
    #end
  #end

  #describe ".hi" do
    #let(:user) {double('User')}
    #let(:username) {'emilsoman'}
    #before(:each) do
      #user.should_receive(:use)
    #end
    #context "when user exists" do
      #it "should just use the user" do
        #User.should_receive(:exists?).and_return true
        #user.should_not_receive(:save)
        #User.should_receive(:new).with(username).and_return user
        #Homer.hi(username)
      #end
    #end
    #context "when user doesn't exist" do
      #it "should clone the repo and use the user" do
        #User.should_receive(:exists?).and_return false
        #user.should_receive(:save).with('dotfiles_repo')
        #User.should_receive(:new).with(username).and_return user
        #Homer.hi(username, 'dotfiles_repo')
      #end
    #end
  #end

  #describe ".bye" do
    #it "should use default user" do
      #Homer.set_config(:default_user, 'emilsoman')
      #user = User.new('emilsoman')
      #FileUtils.mkdir_p(user.dotfiles_directory)
      #File.open(user.homerfile.path, "w") do |f|
        #f << {"Polandie patti" => " samsaarikkaruthu. Atheniku isthamalla"}.to_yaml
      #end
      #user.should_receive(:use)
      #User.should_receive(:new).with('emilsoman').and_return user
      #Homer.bye
    #end
  #end

=begin

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
