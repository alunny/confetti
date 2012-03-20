require 'spec_helper'

describe Confetti::Template::BlackberryWidgetsConfig do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::BlackberryWidgetsConfig
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"blackberry_widgets_config.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/blackberry_widgets_config.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :widget_id }
    it { should respond_to :widget_name }
    it { should respond_to :author_name }
    it { should respond_to :author_email }
    it { should respond_to :author_href }
    it { should respond_to :widget_description }
    it { should respond_to :license_text }
    it { should respond_to :license_href }
  end

  describe "default values" do
    it "should define output filename as \"config.xml\"" do
      @template_class.new.output_filename.should == "config.xml"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.version_string = "1.0.0"
      @config.author.name = "Bruce Lee"
      @config.author.email = "blee@hotmail.com"
      @config.author.href = "http://brucelee.cn"
      @config.description = "My New App, by Bruce Lee"
      @config.phonegap_version = "0.9.5.1"
      @config.access_set << Confetti::Config::Access.new('*', true)
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
        @template.widget_id.should == "com.whoever.awesome.app"
      end

      it "should set display_name correctly" do
        @template.widget_name.should == "Awesome App"
      end

      it "should set description correctly" do
        @template.widget_description.should == "My New App, by Bruce Lee"
      end

      describe "author" do
        it "should set name correctly" do
          @template.author_name.should == "Bruce Lee"
        end

        it "should set href correctly" do
          @template.author_href.should == "http://brucelee.cn"
        end

        it "should set email correctly" do
          @template.author_email.should == "blee@hotmail.com"
        end
      end

      it "should render the correct config.xml" do
        @template.render.should == File.read("#{ fixture_dir }/blackberry/blackberry_widget_config_spec.xml")
      end
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
      @template.app_orientation.should == "auto"
    end
  end

  describe "#widget_id" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should be the default when @config.package is nil" do
      @config.package = nil
      @template.widget_id.should == "com.default.noname"
    end

    it "should be the default when @config.package is an empty string" do
      @config.package = ""
      @template.widget_id.should == "com.default.noname"
    end

    it "should be @config.package when that's set" do
      @config.package = "com.what.not"
      @template.widget_id.should == "com.what.not"
    end
  end

  describe "#version" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should be the default when @config.version_string is nil" do
      @config.version_string = nil
      @template.version.should == "0.0.1"
    end

    it "should be the default when @config.version_string is an empty string" do
      @config.version_string = ""
      @template.version.should == "0.0.1"
    end

    it "should be @config.version_string when that's set" do
      @config.version_string = "1.0.0"
      @template.version.should == "1.0.0"
    end
  end

  describe "#phonegap_version" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should be '1.0.0' if none is defined" do
      @template.phonegap_version.should == "1.0.0"
    end

    it "should be config.phonegap_version if that's below 1.0" do
      @config.phonegap_version = "0.9.5.1"
      @template.phonegap_version.should == "0.9.5.1"
    end

    it "should be '1.0.0' if it's above 1.0" do
      @config.phonegap_version = "1.2.0"
      @template.phonegap_version.should == "1.0.0"
    end
  end

  describe "#no_cursor?" do
    it "should be false with no preference" do
      config = Confetti::Config.new("#{fixture_dir}/config.xml")
      template = @template_class.new(config)
      template.no_cursor?.should be_false
    end

    it "should be true when the preference is set" do
      config = Confetti::Config.new("#{ configs_dir }/no-cursor.xml")
      template = @template_class.new(config)
      template.no_cursor?.should be_true
    end
  end

  describe "#framework_namespace" do
    before do
      @config = Confetti::Config.new("#{fixture_dir}/config.xml")
      @template = @template_class.new(@config)
    end

    it "should be org.apache.cordova by default" do
      @config.phonegap_version = nil
      @template.framework_namespace.should == 'org.apache.cordova'
    end

    it "should be com.phonegap for 0.x" do
      @config.phonegap_version = '0.9.0'
      @template.framework_namespace.should == 'com.phonegap'
    end

    it "should be com.phonegap for 1.4.1" do
      @config.phonegap_version = '1.4.1'
      @template.framework_namespace.should == 'com.phonegap'
    end

    it "should be org.apache.cordova for 1.5.0" do
      @config.phonegap_version = '1.5.0'
      @template.framework_namespace.should == 'org.apache.cordova'
    end

  end

  describe "#access" do
    before do
      @config = Confetti::Config.new
      @template = @template_class.new(@config)
    end

    it "should be empty if there's only a nil tag" do
      @config.access_set << Confetti::Config::Access.new(nil)
      @template.access.should be_empty
    end

    it "should not allow entries with no schemes" do
      @config.access_set << Confetti::Config::Access.new("http://debug.phonegap.com")
      @config.access_set << Confetti::Config::Access.new("docs.phonegap.com")
      @template.access.length.should be 1
    end
  end
end
