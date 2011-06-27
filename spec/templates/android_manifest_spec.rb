require 'spec_helper'

describe Confetti::Template::AndroidManifest do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::AndroidManifest
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"android.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/android_manifest.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :package_name }
    it { should respond_to :class_name }
  end

  describe "default values" do
    it "should define output filename as \"AndroidManifest.xml\"" do
      @template_class.new.output_filename.should == "AndroidManifest.xml"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"

      network_feature = Confetti::Config::Feature.new("http://api.phonegap.com/1.0/network", nil)
      media_feature = Confetti::Config::Feature.new("http://api.phonegap.com/1.0/media", nil)

      @config.feature_set << network_feature
      @config.feature_set << media_feature
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

      it "should set package_name correctly" do
        @template.package_name.should == "com.whoever.awesome.app"
      end

      it "should set class_name correctly" do
        @template.class_name.should == "AwesomeApp"
      end

      it "should use the default version" do
        @template.version.should == "0.0.1"
      end

      it "should render the correct AndroidManifest" do
        @template.render.should == File.read("#{ fixture_dir }/android_manifest_spec.xml")
      end
    end
  end

  describe "permissions method" do
    before do
      @config = Confetti::Config.new

      camera_feature  = Confetti::Config::Feature.new("http://api.phonegap.com/1.0/camera", nil)
      network_feature = Confetti::Config::Feature.new("http://api.phonegap.com/1.0/network", nil)
      media_feature   = Confetti::Config::Feature.new("http://api.phonegap.com/1.0/media", nil)

      @config.feature_set << camera_feature
      @config.feature_set << network_feature
      @config.feature_set << media_feature

      @template = @template_class.new(@config)
    end

    it "should return all of the permissions" do
      # 1 camera, 1 network, 2 media
      @template.permissions.size.should be 4
    end

    # its dumb, but lets me test
    it "should be sorted alphabetically" do
      expected = ["ACCESS_NETWORK_STATE", "CAMERA", "MODIFY_AUDIO_SETTINGS", "RECORD_AUDIO"]
      permission_names = @template.permissions.map { |f| f[:name] }

      permission_names.should == expected
    end
  end

  describe "version code should be set" do
    before do
      @config = Confetti::Config.new
      @config.populate_from_xml("#{fixture_dir}/config_with_version_code.xml")
    end

    it "should have set @config.version_code correctly" do
      @config.version_code.should == "5"
    end
  end
end