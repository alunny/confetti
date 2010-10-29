require 'confetti'

describe Confetti::Config::Feature do
  before do
    @feature = Confetti::Config::Feature.new
  end

  it "should have a readable and writable name field" do
    lambda { @feature.name = "Geolocation" }.should_not raise_error
    @feature.name.should == "Geolocation"
  end

  it "should have a readable and writable required field" do
    lambda { @feature.required = true }.should_not raise_error
    @feature.required.should be_true
  end
end
