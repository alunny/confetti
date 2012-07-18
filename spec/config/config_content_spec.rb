require 'spec_helper'

describe Confetti::Config::Content do
  before do
    @content = Confetti::Config::Content.new
  end

  it "should have a readable and writable src field" do
    lambda { @content.src = "content.html" }.should_not raise_error
    @content.src.should == "content.html"
  end

  it "should have a readable and writable type field" do
    lambda { @content.type = "text/html" }.should_not raise_error
    @content.type.should == "text/html"
  end

  it "should have a readable and writable encoding field" do
    lambda { @content.encoding = "GB2313" }.should_not raise_error
    @content.encoding.should == "GB2313"
  end

  it "should define a defined_attrs method" do
    content = Confetti::Config::Content.new(
      "some/path", "text/html", "utf-8")

    content.defined_attrs.should == {
        "src" => "some/path", "type" => "text/html", "encoding" => "utf-8"
    }
  end
end
