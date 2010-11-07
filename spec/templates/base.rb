require 'confetti'

describe Confetti::Template::Base do
  before :all do
    BaseTemplate = Confetti::Template::Base
  end

  it "should inherit from Mustache" do
    BaseTemplate.superclass.should be Mustache
  end

  it "should have the template_file \"./base.mustache\"" do
    BaseTemplate.template_file.should == "./base.mustache"
  end
end
