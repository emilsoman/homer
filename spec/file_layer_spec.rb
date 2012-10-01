require 'spec_helper'

describe FileLayer do
  describe ".get_generic_home_relative_path" do
    it "should replace /home/xyz/ with ~/" do
      file_path = "/home/emil/somefolder/subfolder/.dotfile"
      FileLayer.get_generic_home_relative_path(file_path).should == "~/somefolder/subfolder/.dotfile"
    end
  end

  describe ".root_path" do
    it "should return the root folder for homer to store meta info" do
      FileLayer.root_path.should == File.join(Dir.home, ".homer") 
    end
  end

  describe ".dotfiles_path" do
    it "should return the path to dotfiles_list" do
      FileLayer.dotfiles_path.should == File.join(Dir.home, ".homer", "dotfiles", "dotfiles_list") 
    end
  end

  describe ".token_path" do
    it "should return the path to file where GitHub token is saved" do
      FileLayer.token_path.should == File.join(Dir.home, ".homer", "token") 
    end
  end

  describe ".dotfiles_directory_path" do
    it "should return the path to folder which will be pushed to GitHub" do
      FileLayer.dotfiles_directory_path.should == File.join(Dir.home, ".homer", "dotfiles/") 
    end
  end

  describe ".save_authorization_token" do
    it "should store token into token file" do
      Homer.init
      FileLayer.save_authorization_token("abc")
      Homer.wipe
    end
  end
  
end
