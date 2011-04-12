require 'spec_helper'

describe Confetti::Template::WebosAppinfo do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::WebosAppinfo
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"webos_appinfo.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/webos_appinfo.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :app_id }
    it { should respond_to :app_name }
    it { should respond_to :version }
  end

  describe "default values" do
    it "should define output filename as \"appinfo.json\"" do
      @template_class.new.output_filename.should == "appinfo.json"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.author.name = "Bruce Lee"
      @config.version_string = "1.0.0"
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

      it "should set app_id correctly" do
        @template.app_id.should == "com.whoever.awesome.app"
      end

      it "should set class_name correctly" do
        @template.app_name.should == "Awesome App"
      end

      it "should set vendor correctly" do
        @template.vendor.should == "Bruce Lee"
      end

      it "should render the correct appinfo.json" do
        @template.render.should == File.read("#{ fixture_dir }/webos_appinfo_spec.json")
      end

      describe "#version method" do
        it "should return the default (0.0.1) when version_string is not set" do
          @config.version_string = nil
          @template.version.should == "0.0.1"
        end

        it "should raise an error if version_string isn't even close" do
          @config.version_string = 'breakfast'
          lambda { @template.version }.should raise_error
        end

        it "should add empty digits if string has one segment" do
          @config.version_string = '1'
          @template.version.should == "1.0.0"
        end

        it "should add empty digits if string has two segments" do
          @config.version_string = '1.1'
          @template.version.should == "1.1.0"
        end

        it "should truncate extra digits if string has too many segments" do
          @config.version_string = '1.2.3.4.5'
          @template.version.should == "1.2.3"
        end

        it "should return config.version when it is valid" do
          @config.version_string = '0.1.0'
          @template.version.should == "0.1.0"
        end
      end
    end
  end
end
