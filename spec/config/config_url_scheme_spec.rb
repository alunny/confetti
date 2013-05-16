require 'spec_helper'

describe Confetti::Config::UrlScheme do
  before do
    @url_scheme = Confetti::Config::UrlScheme.new
  end

  it "should have a readable and writable name field" do
    lambda { @url_scheme.name = "a" }.should_not raise_error
    @url_scheme.name.should == "a"
  end

  it "should have a readable and writable role field" do
    lambda { @url_scheme.role = "a" }.should_not raise_error
    @url_scheme.role.should == "a"
  end
  
  it "should have a readable and writable schemes field" do
    lambda { @url_scheme.schemes = ["a"] }.should_not raise_error
    @url_scheme.schemes.should == ["a"]
  end
end
