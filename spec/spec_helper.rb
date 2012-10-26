$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'homer'
require 'fakefs/spec_helpers'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  #config.before(:each) do
    #Dir.stub(:home).and_return('/tmp')
  #end
  config.include FakeFS::SpecHelpers
end

# FakeFS doesn't support home class method
class FakeFS::Dir
  def self.home
    return RealDir.home
  end
end

# monkey patch for https://github.com/defunkt/fakefs/issues/96
class FakeFS::Dir
  def self.mkdir(path, integer = 0)
    FileUtils.mkdir_p(path) 
  end
end
