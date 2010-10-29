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

  describe "parameter set" do
    it "should have a param_set field, that is a TypedSet" do
      @feature.param_set.should be_a TypedSet
    end

    it "should make the param_set set typed to Confetti::Config::Feature::Param" do
      @feature.param_set.set_class.should be Confetti::Config::Feature::Param
    end

    it "should not allow the param_set to be clobbered" do
      lambda {
        @feature.param_set = { :accuracy => 2.0 }
      }.should raise_error
    end
  end
end
