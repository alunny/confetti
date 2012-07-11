require 'spec_helper'

describe Confetti::Config::Name do
  before do
    @name = Confetti::Config::Name.new
  end

  it "should have a readable and writable name field" do
    lambda {
        @name.name = "Microsoft Windows 7 Ultimate Edition"
        }.should_not raise_error

    @name.name.should == "Microsoft Windows 7 Ultimate Edition"
  end

  it "should have a readable and writable shortname field" do
    lambda { @name.shortname = "Windows7" }.should_not raise_error
    @name.shortname.should == "Windows7"
  end

  it "should define a defined_attrs method" do
    name = Confetti::Config::Name.new( "Long Title", "Short Title" )

    name.defined_attrs.should == {
      "name" => "Long Title", "shortname" => "Short Title"
    }
  end
end
