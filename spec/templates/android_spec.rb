require 'spec_helper'

describe Confetti::Template::Android do
  include HelpfulPaths

  before :all do
    AndroidTemplate = Confetti::Template::Android
  end

  it "should inherit from the base template" do
    AndroidTemplate.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"android.mustache\" in the confetti/templates dir" do
    AndroidTemplate.template_file.should == "#{ templates_dir }/android.mustache"
  end
end
