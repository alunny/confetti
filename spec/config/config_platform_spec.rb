require 'spec_helper'

describe Confetti::Config::Platform do
  before do
    @platform = Confetti::Config::Platform.new("ios")
  end

  it "should have a readable and writable name field" do
    lambda { @platform.name = "ios" }.should_not raise_error
    @platform.name.should == "ios"
  end

  it "should define a defined_attrs method" do
    platform = Confetti::Config::Platform.new("ios")
    
    platform.defined_attrs.should == {
      "name" => "ios"
    }
  end
end
