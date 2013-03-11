$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'homer'
require 'fakefs/spec_helpers'
require 'coveralls'
Coveralls.wear!

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  #config.before(:each) do
    #Dir.stub(:home).and_return('/tmp')
  #end
  config.include FakeFS::SpecHelpers, fakefs: true
end

=begin
# FakeFS doesn't support home class method
class FakeFS::Dir
  def self.home
    return RealDir.home
  end
end
=end

# monkey patch for https://github.com/defunkt/fakefs/issues/96
class FakeFS::Dir
  def self.mkdir(path, integer = 0)
    FileUtils.mkdir_p(path)
  end
end

# monkey patch for File.zero? https://github.com/defunkt/fakefs/pull/181
class FakeFS::File
  def self.zero?(path)
    if exists?(path) and size(path) == 0
      true
    else
      false
    end
  end
end
