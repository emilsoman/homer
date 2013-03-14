require 'spec_helper'

describe Homerfile, fakefs: true do

  describe ".new" do
    it "should set path attribute" do
      dotfiles_directory = File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')
      FileUtils.mkdir_p(dotfiles_directory)
      homerfile = Homerfile.new(dotfiles_directory)
      homerfile.path.should == File.join(dotfiles_directory, 'Homerfile')
    end
  end

  describe "#init" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
      homerfile.stub(:say)
    end
    context "when user adds a non-existent file" do
      it "should create an empty Homerfile" do
        File.exists?(homerfile.path).should be_false
        homerfile.should_receive(:ask).with('Filename: ').and_return('not_a_valid_file')
        homerfile.should_receive(:ask).with('Home relative path: ').and_return(File.join(Dir.home, '.homer', 'symlink'))
        homerfile.should_receive(:agree).and_return(false)
        homerfile.init
        File.size(homerfile.path).should == 0
        File.exists?(File.join(dotfiles_directory, 'not_a_valid_file')).should be_false
      end
    end
    context "when user adds a symlink" do
      it "should create an empty Homerfile" do
        File.exists?(homerfile.path).should be_false
        original_file = File.join(Dir.home, 'symlink')
        symlink_file = File.join(Dir.home, '.homer', 'symlink')
        File.new(original_file, "w")
        File.symlink(original_file, symlink_file)
        homerfile.should_receive(:ask).with('Filename: ').and_return('symlink')
        homerfile.should_receive(:ask).with('Home relative path: ').and_return(File.join(Dir.home, '.homer', 'symlink'))
        homerfile.should_receive(:agree).and_return(false)
        homerfile.init
        File.size(homerfile.path).should == 0
        File.exists?(original_file).should be_true
        File.exists?(symlink_file).should be_true
        File.exists?(File.join(dotfiles_directory, 'symlink')).should be_false
      end
    end
    context "when user adds a valid file" do
      let(:original_file){ "" }
      before(:each) do
        File.exists?(homerfile.path).should be_false
        original_file = File.join(dotfiles_directory, '.valid_file')
        File.new(original_file, "w")
        homerfile.should_receive(:ask).with('Filename: ').and_return('valid_file')
        homerfile.should_receive(:ask).with('Home relative path: ').and_return('~/.homer/emilsoman/dotfiles/.valid_file')
        homerfile.should_receive(:agree).and_return(false)
        homerfile.init
      end
      it "should create a Homerfile with file details" do
        File.read(homerfile.path).should == {'valid_file' => '~/.homer/emilsoman/dotfiles/.valid_file'}.to_yaml
      end
      it "should move original file to dotfiles directory" do
        File.exists?(original_file).should be_false
        File.exists?(File.join(dotfiles_directory, 'valid_file')).should be_true
      end
      context "when init is called again" do
        it "should do nothing and return" do
          File.exists?(homerfile.path).should be_true
          homerfile.should_not_receive(:ask)
          homerfile.should_not_receive(:say)
          previous_homerfile_size = File.size(homerfile.path)
          homerfile.init
          File.size(homerfile.path).should == previous_homerfile_size
        end
      end
    end
  end

  describe "#load" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
      homerfile.dotfiles.should == nil
    end
    context "when homerfile doesn't exist" do
      it "should load empty hash into dotfiles attribute" do
        File.exists?(homerfile.path).should be_false
        homerfile.load
        homerfile.dotfiles.should == {}
      end
    end
    context "when homerfile contains nothing" do
      it "should load empty hash into dotfiles attribute" do
        File.new(File.join(dotfiles_directory, 'Homerfile'), 'w')
        homerfile.load
        homerfile.dotfiles.should == {}
      end
    end
    context "when homerfile contains a hash" do
      it "should load hash into dotfiles attribute" do
        File.open(File.join(dotfiles_directory, 'Homerfile'), 'w') do |f|
          f << {'key' => 'value'}.to_yaml
        end
        homerfile.load
        homerfile.dotfiles.should == {'key' => 'value'}
      end
    end
  end

  describe "#validate!" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
      homerfile.dotfiles.should == nil
    end
    context "when homerfile doesn't exist" do
      it "should raise No Homerfile found  error" do
        File.exists?(homerfile.path).should be_false
        expect{homerfile.validate!}.to raise_error(RuntimeError, "No Homerfile found at #{homerfile.path}")
      end
    end
    context "when homerfile contains nothing" do
      it "should raise Empty Homerfile error" do
        File.new(File.join(dotfiles_directory, 'Homerfile'), 'w')
        expect{homerfile.validate!}.to raise_error(RuntimeError, "Empty Homerfile at #{homerfile.path}")
      end
    end
    context "when homerfile contains corrupted data" do
      it "should raise Homerfile corrupted error" do
        File.open(File.join(dotfiles_directory, 'Homerfile'), 'w') do |f|
          f << 'asdads'
        end
        expect{homerfile.validate!}.to raise_error(RuntimeError, "Homerfile is corrupted. I'm expecting a hash in there")
      end
    end
    context "when homerfile contains a hash" do
      it "should raise any error" do
        File.open(File.join(dotfiles_directory, 'Homerfile'), 'w') do |f|
          f << {'key' => 'value'}.to_yaml
        end
        expect{homerfile.validate!}.to_not raise_error
      end
    end
  end

  describe "#valid?" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
    end
    context "when validate! raises error" do
      before(:each) do
        homerfile.should_receive(:validate!).and_raise(RuntimeError, 'error message')
      end
      it "should return false" do
        homerfile.valid?.should be_false
      end
      it "should set error attribute to exception message" do
        homerfile.valid?
        homerfile.error.should == "error message"
      end
    end

    context "when validate! raises no error" do
      before(:each) do
        homerfile.stub(:validate!)
      end
      it "should return true" do
        homerfile.valid?.should be_true
      end
      it "error attribute should be empty" do
        homerfile.valid?
        homerfile.error.should be_empty
      end
    end
  end

  describe "#save" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
    end
    context "when dotfiles attribute is not a hash" do
      it "should return without doing anything" do
        homerfile.dotfiles = "not a hash"
        File.should_not_receive(:open)
        YAML.should_not_receive(:dump)
        homerfile.save
      end
    end
    context "when dotfiles attribute is hash" do
      it "should open the file and dump dotfiles attr as YAML" do
        homerfile.dotfiles = {'file' => 'filepath'}
        homerfile.save
        YAML.load_file(homerfile.path).should == {'file' => 'filepath'}
      end
    end
  end

  describe "#add_dotfile" do
    let(:dotfiles_directory) {File.join(Dir.home, '.homer', 'emilsoman', 'dotfiles')}
    let(:homerfile) {Homerfile.new(dotfiles_directory)}
    let(:original_file) { File.join(Dir.home, '.valid_file') }
    original_file_size = 0
    before(:each) do
      FileUtils.mkdir_p(dotfiles_directory)
      homerfile.dotfiles.should == nil
      File.open(original_file, "w") do |f|
        f << 'Karutha kozhiku velutha mutta'
      end
      original_file_size = File.size(original_file)
    end
    context "when homerfile doesn't exist" do
      before(:each) do
        File.exists?(homerfile.path).should be_false
        homerfile.add_dotfile('valid_file', '~/.valid_file')
      end
      it "should create a new Homerfile" do
        File.exists?(homerfile.path).should be_true
      end
      it "should add file to Homerfile" do
        YAML.load_file(homerfile.path).should == {'valid_file' => '~/.valid_file'}
      end
      it "should move original file to dotfiles directory" do
        filepath_in_dotfiles_dir = File.join(dotfiles_directory, 'valid_file')
        File.exists?(original_file).should be_false
        File.exists?(filepath_in_dotfiles_dir).should be_true
        File.size(filepath_in_dotfiles_dir).should == original_file_size
      end
    end
    context "when homerfile contains nothing" do
      before(:each) do
        File.new(File.join(dotfiles_directory, 'Homerfile'), 'w')
        File.zero?(homerfile.path).should be_true
        homerfile.add_dotfile('valid_file', '~/.valid_file')
      end
      it "should add file to Homerfile" do
        YAML.load_file(homerfile.path).should == {'valid_file' => '~/.valid_file'}
      end
      it "should move original file to dotfiles directory" do
        filepath_in_dotfiles_dir = File.join(dotfiles_directory, 'valid_file')
        File.exists?(original_file).should be_false
        File.exists?(filepath_in_dotfiles_dir).should be_true
        File.size(filepath_in_dotfiles_dir).should == original_file_size
      end
    end
    context "when homerfile contains a hash" do
      before(:each) do
        File.open(File.join(dotfiles_directory, 'Homerfile'), 'w') do |f|
          f << {'key' => 'value'}.to_yaml
        end
        homerfile.load
        homerfile.dotfiles.should == {'key' => 'value'}
        homerfile.add_dotfile('valid_file', '~/.valid_file')
      end
      it "should add file to Homerfile" do
        YAML.load_file(homerfile.path).should == {'valid_file' => '~/.valid_file', 'key' => 'value'}
      end
      it "should move original file to dotfiles directory" do
        filepath_in_dotfiles_dir = File.join(dotfiles_directory, 'valid_file')
        File.exists?(original_file).should be_false
        File.exists?(filepath_in_dotfiles_dir).should be_true
        File.size(filepath_in_dotfiles_dir).should == original_file_size
      end
    end
    context "when user adds a valid file" do
      before(:each) do
        File.open(File.join(dotfiles_directory, 'Homerfile'), 'w') do |f|
          f << {'key' => 'value'}.to_yaml
        end
        homerfile.load
        homerfile.dotfiles.should == {'key' => 'value'}
        homerfile.add_dotfile('valid_file', '~/.valid_file')
      end
      it "should add file to Homerfile" do
        YAML.load_file(homerfile.path).should == {'valid_file' => '~/.valid_file', 'key' => 'value'}
      end
      it "should move original file to dotfiles directory" do
        filepath_in_dotfiles_dir = File.join(dotfiles_directory, 'valid_file')
        File.exists?(original_file).should be_false
        File.exists?(filepath_in_dotfiles_dir).should be_true
        File.size(filepath_in_dotfiles_dir).should == original_file_size
      end
    end
    context "when user adds a non-existent file" do
      before(:each) do
        expect do
          homerfile.add_dotfile('non-existent-file', '~/.non-existent-file')
        end.to raise_error("No such file or directory - #{File.join(Dir.home, '.non-existent-file')}")
      end
      it "should not create Homerfile" do
        File.exists?(homerfile.path).should be_false
      end
      it "should not move any file" do
        File.exists?(File.join(dotfiles_directory, 'non-existent-file')).should be_false
      end
    end
    context "when user adds a symlink" do
      before(:each) do
        symlink_file = File.join(Dir.home, 'symlink')
        File.symlink(original_file, symlink_file)
        expect do
          homerfile.add_dotfile('symlink', '~/symlink')
        end.to raise_error("File appears to be a symlink. Can't add a symlink.")
      end
      it "should not create Homerfile" do
        File.exists?(homerfile.path).should be_false
      end
      it "should not move any file" do
        File.exists?(File.join(dotfiles_directory, 'symlink')).should be_false
      end
    end
  end

end
