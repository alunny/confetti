require 'confetti'

describe Confetti::Config do
  before do
    @config = Confetti::Config.new
  end

  it "has a writable and readable name field" do
    lambda { @config.name = "My Great App" }.should_not raise_error
    @config.name.should == "My Great App"
  end

  it "has a writable and readable package field" do
    lambda { @config.package = "com.alunny.greatapp" }.should_not raise_error
    @config.package.should == "com.alunny.greatapp"
  end

  it "has a writable and readable version field" do
    lambda { @config.version = "0.1.0" }.should_not raise_error
    @config.version.should == "0.1.0"
  end

  it "has a writable and readable description field" do
    lambda { @config.description = "A Great App That Lets You Do Things" }.should_not raise_error
    @config.description.should == "A Great App That Lets You Do Things"
  end

  it "has an author field, that is an author object" do
    @config.author.class.should be Confetti::Config::Author
  end
end
