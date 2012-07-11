require 'spec_helper'

describe Confetti::Config::Access do
  before do
    @access = Confetti::Config::Access.new
  end

  it "should define a defined_attrs method" do
    access = Confetti::Config::Access.new( "google.ca", true, false )

    access.defined_attrs.should == {
      "origin" => "google.ca",
      "subdomains" => true,
      "browserOnly" => false
    }
  end
end
