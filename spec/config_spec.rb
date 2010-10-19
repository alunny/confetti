require 'confetti'

describe Confetti::Config do
  before do
    @config = Confetti::Config.new
  end

  it "has a writable and readable name field" do
    @config.name = "My Great App"
    @config.name.should == "My Great App"
  end

  it "has a writable and readable package field" do
    @config.package = "com.alunny.greatapp"
    @config.package.should == "com.alunny.greatapp"
  end

  it "has a writable and readable version field" do
    @config.version = "0.1.0"
    @config.version.should == "0.1.0"
  end

  it "has a writable and readable description field" do
    @config.description = "A Great App That Lets You Do Things"
    @config.description.should == "A Great App That Lets You Do Things"
  end
end
