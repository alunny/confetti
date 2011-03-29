require 'spec_helper'

describe Confetti::Config::Image do
  before do
    @image = Confetti::Config::Image.new
  end

  it "should have a readable and writable src field" do
    lambda { @image.src = "icon.png" }.should_not raise_error
    @image.src.should == "icon.png"
  end

  it "should have a readable and writable width field" do
    lambda { @image.width = 50 }.should_not raise_error
    @image.width.should == 50
  end

  it "should have a readable and writable height field" do
    lambda { @image.height = 50 }.should_not raise_error
    @image.height.should == 50
  end
end
