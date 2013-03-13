require 'spec_helper'

describe Symlink, fakefs: true do
  describe ".create" do
    let(:file) { File.join(Dir.home, 'file') }
    let(:target) { File.join(Dir.home, 'target')  }
    before(:each) do
      FileUtils.mkdir_p(Dir.home)
      File.new(file, "w")
    end
    context "when source file does not exist" do
      it "should not create a symlink" do
        File.delete(file)
        Symlink.should_receive(:say).with("<%= color('#{file} does not exist. Can't symlink this file.', :red) %>")
        Symlink.create(file, target)
        File.exists?(target).should be_false
      end
    end
    context "when target is a symlink" do
      it "should replace the symlink with the new one" do
        another_file = File.join(Dir.home, 'another_file')
        File.new(another_file, 'w')
        File.symlink(another_file, target)
        Symlink.should_receive(:say).with("<%= color('Symlink already exists at #{target}. Overwriting with #{file}', :yellow) %>")
        Symlink.create(file, target)
        File.symlink?(target).should be_true
        File.readlink(target).should == file
      end
    end
    context "when target is a file" do
      it "should not create a symlink overwriting the file" do
        another_file = File.join(Dir.home, 'target')
        File.new(another_file, 'w')
        Symlink.should_receive(:say).with("<%= color('File already exists at #{target}. Not linking #{file}', :red) %>")
        Symlink.create(file, target)
        File.exists?(target).should be_true
        File.symlink?(target).should be_false
      end
    end
    context "when target file does not exist" do
      context "when target directory does not exist" do
        it "should create the directory and create symlink" do
          target = File.join(Dir.home, 'new_dir', 'target')
          Symlink.create(file, target)
          File.symlink?(target).should be_true
          File.readlink(target).should == file
        end
      end
      context "when target directory exists" do
        it "should create the symlink in the directory" do
          target = File.join(Dir.home, 'target')
          Symlink.create(file, target)
          File.symlink?(target).should be_true
          File.readlink(target).should == file
        end
      end
    end
  end
end
