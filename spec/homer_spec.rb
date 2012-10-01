require 'spec_helper'

describe Homer do
  describe "initialize" do
    before (:each) do
      Homer.wipe
      Homer.init
    end
    it "should create a .homer folder in home directory" do
      Dir.exists?(File.join(Dir.home, '.homer')).should be_true
    end
    it "should create a .homer folder in home directory" do
      Dir.exists?(File.join(Dir.home,'.homer/dotfiles')).should be_true
    end
    it "should create an empty dotfiles file in ~/.homer" do
      File.zero?(File.join(Dir.home,'.homer/dotfiles/dotfiles_list')).should be_true
    end
  end

  describe "adding a dotfile" do
    context "when dotfile doesnt exist" do
      it "should raise error when dotfile does not exist" do
        expect do
          Homer.add('~/.file_that_does_not_exist')
        end.to raise_error("#{ENV['HOME']}/.file_that_does_not_exist does not exist.")
        #File.read(Homer.dotfiles_path).should include(File.join(Dir.home, ".file_that_does_not_exist"))
      end
    end
    context "when dotfile exists" do
      it "should raise error when dotfile does not exist" do
        File.new("/tmp/.file_that_exists", "w")
        File.new("/tmp/.another_file_that_exists", "w")
        expect do
          Homer.add('/tmp/.file_that_exists')
          Homer.add('/tmp/.another_file_that_exists')
        end.not_to raise_error
        YAML.load_file(FileLayer.dotfiles_path).should == {".file_that_exists" => '/tmp/.file_that_exists', ".another_file_that_exists" => '/tmp/.another_file_that_exists'}
        File.delete(File.join(Dir.home, ".file_that_exists"))
        File.delete(File.join(Dir.home, ".another_file_that_exists"))
        Homer.wipe
      end
    end
  end

  describe ".list" do
    it "should list the contents of dotfiles" do
      Homer.wipe
      Homer.init
      File.new(File.join(Dir.home, ".file_that_exists"), "w")
      File.new(File.join(Dir.home, ".another_file_that_exists"), "w")
      Homer.add(File.join(Dir.home, ".file_that_exists"))
      Homer.add(File.join(Dir.home, ".another_file_that_exists"))
      Homer.list.should include(".file_that_exists")
      Homer.list.should include(".another_file_that_exists")
      File.delete(File.join(Dir.home, ".file_that_exists"))
      File.delete(File.join(Dir.home, ".another_file_that_exists"))
      Homer.wipe
    end
  end

end
