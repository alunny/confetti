require 'spec_helper'

describe Confetti::PhoneGap::Plugin do
  before do
    @child = Confetti::PhoneGap::Plugin.new("ChildBrowser", "~2.0")
  end

  it "should have a readable and writable name field" do
    lambda { @child.name = "MediaBrowser" }.should_not raise_error
    @child.name.should == "MediaBrowser"
  end

  it "should have a readable and writable version field" do
    lambda { @child.version = "1.0" }.should_not raise_error
    @child.version.should == "1.0"
  end

  describe "parameter set" do
    it "should have a param_set field, that is a TypedSet" do
      @child.param_set.should be_a TypedSet
    end

    it "should make the param_set set typed to Confetti::Config::Param" do
      @child.param_set.set_class.should be Confetti::Config::Param
    end

    it "should not allow the param_set to be clobbered" do
      lambda {
        @child.param_set = { :accuracy => 2.0 }
      }.should raise_error
    end
  end
end
