require 'spec_helper'

describe Confetti::Config::Icon do
  before do
    @icon = Confetti::Config::Icon.new
  end

  it "should have a readable and writable src field" do
    lambda { @icon.src = "icon.png" }.should_not raise_error
    @icon.src.should == "icon.png"
  end

  it "should have a readable and writable width field" do
    lambda { @icon.width = 50 }.should_not raise_error
    @icon.width.should == 50
  end

  it "should have a readable and writable height field" do
    lambda { @icon.height = 50 }.should_not raise_error
    @icon.height.should == 50
  end
end
