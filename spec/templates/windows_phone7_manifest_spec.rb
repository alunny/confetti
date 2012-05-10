require 'spec_helper'

describe Confetti::Template::WindowsPhone7Manifest do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::WindowsPhone7Manifest
  end

  it "should have the base class of Confetti::Template" do
    @template_class.superclass.should == Confetti::Template::Base
  end

  it "should have a valid WMAppManifest mustace template" do
    @template_class.template_file.should == "#{ templates_dir }/windows_phone7_manifest.mustache"
  end

  describe "attributes" do
    subject { @template = @template_class.new }
    
    it { should respond_to :title }
    it { should respond_to :author }
    it { should respond_to :guid }
    it { should respond_to :description }
    it { should respond_to :version }
    it { should respond_to :capabilities }
  end

  it "should provide a 128 bit guid" do
    @config = Confetti::Config.new
    @config.package = "com.example.www"
    @template = @template_class.new @config
    @template.guid.should == "{1005a3fc-23ab-99bd-bdd1-9e83f3d7b989}" 
  end

  describe "with a bad config object" do

    describe "on rendering" do

      it "should generate a dummy uuid if non provided" do
        @config = Confetti::Config.new
        @config.package = "com.example.app"
        @template = @template_class.new @config
        @template.guid.should == "{a163ec9b-9996-caee-009d-cdac1b7e0722}"
      end

      it "should not fail when a bad feature is found" do
        @config = Confetti::Config.new
        bad_feature = Confetti::Config::Feature.new(
            "http://api.phonegap.com/1.0/badfeature",
            "true"
            )
        good_feature = Confetti::Config::Feature.new(
            "http://api.phonegap.com/1.0/network",
            "true"
            )
        @config.feature_set << bad_feature
        @config.feature_set << good_feature
        @template = @template_class.new @config
        @template.capabilities.should == [{:name => "ID_CAP_NETWORKING"}]
      end
    end
  end

  describe "with a good config object" do

    describe "on rendering" do

      it "should render a valid wp7 manifest" do
        @config = Confetti::Config.new "#{fixture_dir}/config.xml"
        @template = @template_class.new @config 
        @template.render.should == File.read(
            "#{fixture_dir}/windowsphone7/WMAppManifest.xml"
          )
      end

      it "should add a feature when a valid on is found" do
        @config = Confetti::Config.new
        feature = Confetti::Config::Feature.new(
            "http://api.phonegap.com/1.0/geolocation",
            "true"
            )
        @config.feature_set << feature 
        @template = @template_class.new @config
        @template.capabilities.should == [{:name=>"ID_CAP_LOCATION"}]
      end

      it "should add default capabilities when none are specified" do
        @config = Confetti::Config.new
        @template = @template_class.new @config
        @template.capabilities.should == [
            {:name => "ID_CAP_CONTACTS"},
            {:name => "ID_CAP_IDENTITY_DEVICE"},
            {:name => "ID_CAP_ISV_CAMERA"},
            {:name => "ID_CAP_LOCATION"},
            {:name => "ID_CAP_MICROPHONE"},
            {:name => "ID_CAP_NETWORKING"},
            {:name => "ID_HW_FRONTCAMERA"},
        ]
      end

      it "should no add any capabilities when preference permissions is none" do
        @config = Confetti::Config.new
        @template = @template_class.new @config
        @config.preference_set <<
            Confetti::Config::Preference.new("permissions", "none")
        @template.capabilities.should == []
      end
    end
  end

  describe "should write a valid manifest file" do

    it "should write the file" do
        @config = Confetti::Config.new
        @config.feature_set <<
            Confetti::Config::Feature.new(
                "http://plugins.phonegap.com/ChildBrowser/2.0.1",
                'true'
                )
        @config.feature_set <<
            Confetti::Config::Feature.new(
                "http://api.phonegap.com/1.0/geolocation",
                'true'
                )
        @template = @template_class.new @config
        @template.capabilities.should == [
            {:name => "ID_CAP_LOCATION"},
        ]
        lambda { @template.render }.should_not raise_error
    end
  end
end
