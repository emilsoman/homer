require 'spec_helper'

describe FileLayer do

  describe ".init" do
    let(:root_path) {FileLayer.root_path}
    let(:dotfiles_directory_path) {FileLayer.dotfiles_directory_path}
    context "when root_path exists" do
      it "should do nothing" do
        Dir.mkdir(root_path)
        Dir.exists?(root_path).should be_true
        modification_time = File.mtime(root_path)
        FileLayer.init
        File.mtime(root_path).to_i.should == modification_time.to_i
      end
    end
    context "when root_path does not exist" do
      it "should create root_path" do
        Dir.exists?(root_path).should be_false
        FileLayer.init
        Dir.exists?(root_path).should be_true
      end
    end

    context "when dotfiles_directory_path exists" do
      it "should do nothing" do
        Dir.mkdir(dotfiles_directory_path)
        Dir.exists?(dotfiles_directory_path).should be_true
        modification_time = File.mtime(dotfiles_directory_path)
        FileLayer.init
        File.mtime(dotfiles_directory_path).to_i.should == modification_time.to_i
      end
    end
    context "when dotfiles_directory_path does not exist" do
      it "should create dotfiles_directory_path" do
        Dir.exists?(dotfiles_directory_path).should be_false
        FileLayer.init
        Dir.exists?(dotfiles_directory_path).should be_true
      end
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

  describe ".room_path" do
    it "should return the path to folder which will be used for github login" do
      FileLayer.room_path('login').should == File.join(FileLayer.root_path, "room/login") 
    end
  end

  describe ".current_room_path" do
    it "should return the path to folder which will be used for current user" do
      FileLayer.current_room_path.should == File.join(FileLayer.root_path, "current") 
    end
  end

  describe ".current_room_dotfiles_path" do
    it "should return the path to dotfiles list for current user" do
      FileLayer.current_room_dotfiles_path.should == File.join(FileLayer.current_room_path, "dotfiles/dotfiles_list.yml") 
    end
  end

  describe ".backup_path" do
    it "should return the path to folder where backup is stored" do
      FileLayer.backup_path.should == File.join(FileLayer.root_path, "backup") 
    end
  end

  describe ".backup_list_path" do
    it "should return the path to list of backup files" do
      FileLayer.backup_list_path.should == File.join(FileLayer.backup_path, "backup_list.yml") 
    end
  end

  describe ".get_generic_home_relative_path" do
    it "should replace /home/xyz/ with ~/" do
      file_path = File.join( Dir.home, '/somefolder/subfolder/.dotfile')
      FileLayer.get_generic_home_relative_path(file_path).should == "~/somefolder/subfolder/.dotfile"
    end
    it "should replace /home/xyz/home/xyz with ~/home/xyz" do
      file_path = File.join( Dir.home, Dir.home ,'/somefolder/subfolder/.dotfile')
      FileLayer.get_generic_home_relative_path(file_path).should == "~#{Dir.home}/somefolder/subfolder/.dotfile"
    end
  end

end
