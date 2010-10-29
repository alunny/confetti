require 'confetti'

describe Confetti::Config do
  before do
    @config = Confetti::Config.new
  end

  #### fields on the widget element

  it "has a writable and readable package field" do
    lambda { @config.package = "com.alunny.greatapp" }.should_not raise_error
    @config.package.should == "com.alunny.greatapp"
  end

  it "has a writable and readable version field" do
    lambda { @config.version = "0.1.0" }.should_not raise_error
    @config.version.should == "0.1.0"
  end

  it "has a writable and readable height field" do
    lambda { @config.height = 500 }.should_not raise_error
    @config.height.should == 500
  end

  it "has a writable and readable width field" do
    lambda { @config.width = 500 }.should_not raise_error
    @config.width.should == 500
  end

  it "has a list of viewmodes" do
    @config.viewmodes.should be_an Array
  end

  it "should let viewmodes be appended" do
    @config.viewmodes << "windowed"
    @config.viewmodes << "floating"
    @config.viewmodes.should == ["windowed","floating"]
  end

  it "has a writable and readable description field" do
    lambda { @config.description = "A Great App That Lets You Do Things" }.should_not raise_error
    @config.description.should == "A Great App That Lets You Do Things"
  end

  #### child elements

  it "has a name field, that is a name object"

  it "has an author field, that is an author object" do
    @config.author.class.should be Confetti::Config::Author
  end

  it "doesn't allow author to be clobbered" do
    lambda { @config.author = "Andrew Lunny" }.should raise_error
  end
end
