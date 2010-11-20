require 'spec_helper'

describe Confetti::Template::AndroidManifest do
  include HelpfulPaths

  before :all do
    AndroidTemplate = Confetti::Template::AndroidManifest
  end

  it "should inherit from the base template" do
    AndroidTemplate.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"android.mustache\" in the confetti/templates dir" do
    AndroidTemplate.template_file.should == "#{ templates_dir }/android_manifest.mustache"
  end

  describe "templated attributes" do
    subject { @template = AndroidTemplate.new }

    it { should respond_to :package_name }
    it { should respond_to :class_name }
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
    end

    it "should accept the config object" do
      lambda {
        AndroidTemplate.new(@config)
      }.should_not raise_error
    end

    describe "templated attributes" do
      before do
        @template = AndroidTemplate.new(@config)
      end

      it "should set package_name correctly" do
        @template.package_name.should == "com.whoever.awesome.app"
      end

      it "should set class_name correctly" do
        @template.class_name.should == "Awesome_App"
      end
    end
  end
end
