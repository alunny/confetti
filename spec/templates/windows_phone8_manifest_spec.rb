require 'spec_helper'

describe Confetti::Template::WindowsPhone8Manifest do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::WindowsPhone8Manifest
  end

  it "should have the base class of Confetti::Template" do
    @template_class.superclass.should == Confetti::Template::Base
  end

  it "should have a valid WMAppManifest mustace template" do
    @template_class.template_file.should == "#{ templates_dir }/windows_phone8_manifest.mustache"
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
            "#{fixture_dir}/windowsphone8/WMAppManifest.xml"
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

  describe "description" do
    before do
      @config = Confetti::Config.new "#{fixture_dir}/config-long-desc.xml"
      @template = @template_class.new(@config)
    end

    it "should truncate the description to < 250 characters" do
      @template.description.length.should be < 250
    end
  end

  describe "version" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should normalize the version to four parts" do
      @config.version_string = "1.0.0"
      @template.version.should == "1.0.0.0"
    end

    it "should ensure the non-initial numbers are one digit" do
      # THIS IS STUPID
      @config.version_string = "2012.05.20"
      @template.version.should == "2012.0.2.0"
    end

    it "should ensure letters are converted to numbers" do
      @config.version_string = "1.3.a"
      @template.version.should == "1.3.0.0"
    end
  end

  describe "author" do
    before do
      @config = Confetti::Config.new "spec/fixtures/config.xml"
      @template = @template_class.new(@config)
    end

    it "should return the Confetti Author name in the normal case" do
      @template.author.should == "Andrew Lunny"
    end

    it "should truncate the field to 50 chars or less" do
      me = "Andrew John Lunny, son of William and Vivian, brother of Hugo"
      short = "Andrew John Lunny, son of William and Vivian, brot"
      @config.author.name = me
      @template.author.should == short
    end
  end
end
