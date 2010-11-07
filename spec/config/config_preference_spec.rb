require 'spec_helper'

describe Confetti::Config::Preference do
  before do
    @pref = Confetti::Config::Preference.new
  end

  it "should have a readable and writable name field" do
    lambda { @pref.name = "Auto-Rotation" }.should_not raise_error
    @pref.name.should == "Auto-Rotation"
  end

  it "should have a readable and writable value field" do
    lambda { @pref.value = "disabled" }.should_not raise_error
    @pref.value.should == "disabled"
  end

  it "should have a readable and writable readonly field" do
    lambda { @pref.readonly = true }.should_not raise_error
    @pref.readonly.should be_true
  end
end
