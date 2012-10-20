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
      FileLayer.dotfiles_path.should == File.join(Dir.home, ".homer", "dotfiles", "dotfiles_list.yml") 
    end
  end

  describe ".dotfiles_directory_path" do
    it "should return the path to folder which will be pushed to GitHub" do
      FileLayer.dotfiles_directory_path.should == File.join(Dir.home, ".homer", "dotfiles/") 
    end
  end

end
