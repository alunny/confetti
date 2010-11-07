require 'spec_helper'

describe Confetti::Template::Base do
  include HelpfulPaths

  before :all do
    BaseTemplate = Confetti::Template::Base
  end

  it "should inherit from Mustache" do
    BaseTemplate.superclass.should be Mustache
  end

  it "should have the template_file \"base.mustache\" in the confetti/templates dir" do
    BaseTemplate.template_file.should == "#{ templates_dir }/base.mustache"
  end

  it "should find the template and render without error" do
    lambda { BaseTemplate.new.render }.should_not raise_error
  end
end
