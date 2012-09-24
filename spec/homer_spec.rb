require 'spec_helper'

describe Homer do
  describe "initialize" do
    before (:each) do
      Homer.wipe
      Homer.init
    end
    it "should create a .homer folder in home directory" do
      Dir.exists?(ENV['HOME']+'/.homer').should be_true
    end
    it "should create an empty dotfiles file in ~/.homer" do
      File.zero?(ENV['HOME']+'/.homer/dotfiles').should be_true
    end
  end

  describe "adding a dotfile" do
    context "when dotfile doesnt exist" do
      it "should raise error when dotfile does not exist" do
        expect do
          Homer.add('~/.file_that_does_not_exist')
        end.to raise_error("/home/emil/.file_that_does_not_exist does not exist.")
        #File.read(Homer.dotfiles_path).should include(File.join(Dir.home, ".file_that_does_not_exist"))
      end
    end
    context "when dotfile exists" do
      it "should raise error when dotfile does not exist" do
        File.new(File.join(Dir.home, ".file_that_exists"), "w")
        File.new(File.join(Dir.home, ".another_file_that_exists"), "w")
        expect do
          Homer.add('~/.file_that_exists')
          Homer.add('~/.another_file_that_exists')
        end.not_to raise_error
        File.read(FileLayer.dotfiles_path).should include(File.join(Dir.home, ".file_that_exists"))
        File.read(FileLayer.dotfiles_path).should include(File.join(Dir.home, ".another_file_that_exists"))
        File.delete(File.join(Dir.home, ".file_that_exists"))
        File.delete(File.join(Dir.home, ".another_file_that_exists"))
      end
    end
  end

  describe ".list" do
    Homer.wipe
    Homer.init
    File.new(File.join(Dir.home, ".file_that_exists"), "w")
    File.new(File.join(Dir.home, ".another_file_that_exists"), "w")
    it "should list the contents of dotfiles" do
      Homer.list.should include(File.join(Dir.home, ".file_that_exists"))
      Homer.list.should include(File.join(Dir.home, ".another_file_that_exists"))
    end
    File.delete(File.join(Dir.home, ".file_that_exists"))
    File.delete(File.join(Dir.home, ".another_file_that_exists"))
  end

end
