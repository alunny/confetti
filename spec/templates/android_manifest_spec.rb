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
        @template.render.should == File.read("#{ fixture_dir }/android/android_manifest_spec.xml")
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
      # 1 camera, 1 network, 3 media
      @template.permissions.size.should be 5
    end

    # its dumb, but lets me test
    it "should be sorted alphabetically" do
      expected = ["ACCESS_NETWORK_STATE", "CAMERA", "MODIFY_AUDIO_SETTINGS", "RECORD_AUDIO", "RECORD_VIDEO"]
      permission_names = @template.permissions.map { |f| f[:name] }

      permission_names.should == expected
    end

    describe "when preference specifies no permissions" do
      before do
        bare_config = "#{ fixture_dir }/configs/config_bare.xml"
        @config = Confetti::Config.new bare_config
        @template = @template_class.new(@config)
      end

      it "should only render the INTERNET permission" do
        bare_manifest = File.read "#{ fixture_dir }/android/AndroidManifest_bare.xml"
        @template.render.should == bare_manifest
      end
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

  describe "#app_orientation" do
    before do
      @config = Confetti::Config.new
      @orientation_pref = Confetti::Config::Preference.new "orientation"
      @config.preference_set << @orientation_pref
      @template = @template_class.new(@config)
    end

    it "should return the right array for portrait orientation" do
      @orientation_pref.value = "portrait"
      @template.app_orientation.should == "portrait"
    end

    it "should return the right array for landscape orientation" do
      @orientation_pref.value = "landscape"
      @template.app_orientation.should == "landscape"
    end

    it "should return the right array for default orientation" do
      @orientation_pref.value = "default"
      @template.app_orientation.should == "unspecified"
    end
  end

  describe "#install_location" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should default to 'internalOnly' do" do
      @template.install_location.should == "internalOnly"
    end

    describe "when set" do
      before do
        @install_pref = Confetti::Config::Preference.new "android-installLocation"
        @config.preference_set << @install_pref
      end

      it "should use 'auto' when set to 'auto'" do
        @install_pref.value = "auto"
        @template.install_location.should == "auto"
      end

      it "should use 'preferExternal' when set to 'preferExternal'" do
        @install_pref.value = "preferExternal"
        @template.install_location.should == "preferExternal"
      end

      it "should use 'internalOnly' otherwise" do
        @install_pref.value = "wherever"
        @template.install_location.should == "internalOnly"
      end
    end
  end

  describe "#min_sdk_version" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
      @default = @template_class::DEFAULT_MIN_SDK
    end

    it "should default to the current default" do
      @template.min_sdk_version.should == @default
    end

    describe "when set" do
      before do
        @sdk_pref = Confetti::Config::Preference.new "android-minSdkVersion"
        @config.preference_set << @sdk_pref
      end

      it "should return that number" do
        @sdk_pref.value = "12"
        @template.min_sdk_version.should == "12"
      end

      it "should be nil if not a number" do
        @sdk_pref.value = "twelve"
        @template.min_sdk_version.should == @default
      end
    end
  end

  describe "#max_sdk_version_attribute" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should default to nil" do
      @template.max_sdk_version_attribute.should be_nil
    end

    describe "when set" do
      before do
        @sdk_pref = Confetti::Config::Preference.new "android-maxSdkVersion"
        @config.preference_set << @sdk_pref
      end

      it "should return that number" do
        @sdk_pref.value = "12"
        @template.max_sdk_version_attribute.should == 'android:maxSdkVersion="12"'
      end

      it "should be nil if not a number" do
        @sdk_pref.value = "twelve"
        @template.max_sdk_version_attribute.should be_nil
      end
    end
  end
end
