require 'spec_helper'

describe Confetti::Config::Author do
  before do
    @author = Confetti::Config::Author.new
  end

  it "should have a readable and writable name field" do
    lambda { @author.name = "Andrew Lunny" }.should_not raise_error
    @author.name.should == "Andrew Lunny"
  end

  it "should have a readable and writable href field" do
    lambda {
        @author.href = "http://alunny.github.com"
        }.should_not raise_error

    @author.href.should == "http://alunny.github.com"
  end

  it "should have a readable and writable email field" do
    lambda { @author.email = "alunny@gmail.com" }.should_not raise_error
    @author.email.should == "alunny@gmail.com"
  end

  it "should define a defined_attrs method" do
    author = Confetti::Config::Author.new(
        "hardeep", "127.0.0.1", "shardeep@adobe.com")

    author.defined_attrs.should == {
      "name" => "hardeep",
      "href" => "127.0.0.1",
      "email" => "shardeep@adobe.com"
    }
  end
end
