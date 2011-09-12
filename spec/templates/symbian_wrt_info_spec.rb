require 'spec_helper'

describe Confetti::Template::SymbianWrtInfo do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::SymbianWrtInfo
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"symbian_wrt_info.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/symbian_wrt_info.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :display_name }
    it { should respond_to :identifier }
    it { should respond_to :version }
  end

  describe "default values" do
    it "should define output filename as \"info.plist\"" do
      @template_class.new.output_filename.should == "info.plist"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.version_string = "1.0.0"
      @feature_set = TypedSet.new Confetti::Config::Feature
      @feature_set << Confetti::Config::Feature.new("http://api.phonegap.com/1.0/network", "true")
      @config.stub(:feature_set).and_return @feature_set
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

      it "should set identifier correctly" do
        @template.identifier.should == "com.whoever.awesome.app"
      end

      it "should set display_name correctly" do
        @template.display_name.should == "Awesome App"
      end

      it "should set version correctly" do
        @template.version.should == "1.0.0"
      end

      it "should set version correctly with not config.xml" do
        @config = Confetti::Config.new
        @template = @template_class.new(@config)
        @template.version.should == "1.0"
      end

      it "should render the correct info.plist" do
        @template.render.should == File.read("#{ fixture_dir }/symbian/symbian_wrt_info_spec.plist")
      end
    end
  end
end
