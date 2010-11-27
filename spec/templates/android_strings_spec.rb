require 'spec_helper'

describe Confetti::Template::AndroidStrings do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::AndroidStrings
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"android_strings.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/android_strings.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :app_name }
  end

  describe "default values" do
    it "should define output filename as \"strings.xml\"" do
      @template_class.new.output_filename.should == "strings.xml"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
    end

    it "should accept the config object" do
      lambda {
        @template_class.new(@config)
      }.should_not raise_error
    end

    describe "templated attributes" do
      before do
        @template = @template_class.new(@config)
      end

      it "should set app_name correctly" do
        @template.app_name.should == "Awesome App"
      end

      it "should render the correct AndroidManifest" do
        @template.render.should == File.read("#{ fixture_dir }/android_strings_spec.xml")
      end
    end
  end
end
