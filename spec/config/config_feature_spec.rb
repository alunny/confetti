require 'spec_helper'

describe Confetti::Config::Feature do
  include HelpfulPaths

  before do
    @feature = Confetti::Config::Feature.new("Geolocation", nil)
  end

  it "should have a readable and writable name field" do
    lambda { @feature.name = "Geolocation" }.should_not raise_error
    @feature.name.should == "Geolocation"
  end

  it "should have a readable and writable required field" do
    lambda { @feature.required = true }.should_not raise_error
    @feature.required.should be_true
  end

  describe "parameter set" do
    it "should have a param_set field, that is a TypedSet" do
      @feature.param_set.should be_a TypedSet
    end

    it "should make the param_set set typed to Confetti::Config::Param" do
      @feature.param_set.set_class.should be Confetti::Config::Param
    end

    it "should not allow the param_set to be clobbered" do
      lambda {
        @feature.param_set = { :accuracy => 2.0 }
      }.should raise_error
    end
  end

  it "should define a defined_attrs method" do
    feature = Confetti::Config::Feature.new( "Geolocation", true )
    
    feature.defined_attrs.should == {
      "name" => "Geolocation",
      "required" => true 
    }
  end

  context "with a config.xml" do

    before :each do
      @config = Confetti::Config.new "#{ fixture_dir }/config-features.xml"
    end

    it "should read the feature's param set" do
      feature = @config.feature_set.detect{ | f | f.name == "notification" }
      feature.param_set.length.should == 2
    end
  end
end
