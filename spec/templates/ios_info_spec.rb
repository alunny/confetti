require 'spec_helper'

describe Confetti::Template::IosInfo do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::IosInfo
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"ios_info.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/ios_info.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :bundle_identifier }
    it { should respond_to :product_name }
    it { should respond_to :bundle_version }
  end

  describe "default values" do
    it "should define output filename as \"Info.plist\"" do
      @template_class.new.output_filename.should == "Info.plist"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.version_string = "1.0.0"
      @config.plist_icon_set = ['icon.png']
      pref = Confetti::Config::Preference.new("universal", "true", nil)
      @config.preference_set << pref    
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

      it "should set bundle_identifier correctly" do
        @template.bundle_identifier.should == "com.whoever.awesome.app"
      end

      it "should set product_name correctly" do
        @template.product_name.should == "Awesome App"
      end

      it "should set bundle_version correctly" do
        @template.bundle_version.should == "1.0.0"
      end

      it "should render the correct Info.plist" do
        @template.render.should == File.read("#{ fixture_dir }/ios/ios_info_spec.plist")
      end
    end
  end

  describe "#app_orientations" do
    before do
      @config = Confetti::Config.new
      @orientation_pref = Confetti::Config::Preference.new "orientation"
      @config.preference_set << @orientation_pref
      @template = @template_class.new(@config)

      @portrait = %w{UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown}
      @landscape = %w{UIInterfaceOrientationLandscapeRight UIInterfaceOrientationLandscapeLeft}
      @default = @portrait + @landscape
    end

    it "should return the right array for portrait orientation" do
      @orientation_pref.value = "portrait"

      # check that contents are matching
      # a little longwinded
      difference = @portrait - @template.app_orientations
      difference.should be_empty
    end

    it "should return the right array for landscape orientation" do
      @orientation_pref.value = "landscape"

      difference = @landscape - @template.app_orientations
      difference.should be_empty
    end

    it "should return the right array for default orientation" do
      @orientation_pref.value = "default"

      difference = @default - @template.app_orientations
      difference.should be_empty
    end
  end

  describe "ios icons" do
    before do
      @config = Confetti::Config.new("#{fixture_dir}/config_with_orientation.xml")
      @template = @template_class.new(@config)
    end

    it "should populate the info.plist with the icons" do
      @template.render.should == File.read("#{ fixture_dir }/ios/ios_info_spec_expected_orientation.plist")
    end
  end

  describe "should specify if the application is universal" do
    before do
      @config = Confetti::Config.new("#{fixture_dir}/config.xml")
      @template = @template_class.new(@config)
    end
    
    it "should should specify universal" do
      @template.render.should == File.read("#{ fixture_dir }/ios/ios_info_expected.plist")
    end
  end

  describe "#fullscreen? method" do
    it "should be false with no preference" do
      config = Confetti::Config.new("#{fixture_dir}/config.xml")
      template = @template_class.new(config)
      template.fullscreen?.should be_false
    end

    it "should be true when the preference is set" do
      config = Confetti::Config.new("#{fixture_dir}/config_fullscreen.xml")
      template = @template_class.new(config)
      template.fullscreen?.should be_true
    end
  end

  describe "#prerendered_icon? method" do
    it "should be false with no preference" do
      config = Confetti::Config.new("#{fixture_dir}/config.xml")
      template = @template_class.new(config)
      template.prerendered_icon?.should be_false
    end

    it "should be true when the preference is set" do
      config = Confetti::Config.new("#{ configs_dir }/prerendered.xml")
      template = @template_class.new(config)
      template.prerendered_icon?.should be_true
    end
  end

  describe "#statusbar_style method" do
    before do
      @config = Confetti::Config.new("#{fixture_dir}/config.xml")
      @template = @template_class.new(@config)
    end

    it "should be nil with no preference" do
      @template.statusbar_style.should be_nil
    end

    describe "when set" do
      before do
        @status_pref = Confetti::Config::Preference.new("ios-statusbarstyle")
        @config.preference_set << @status_pref
      end

      it "should be UIStatusBarStyleDefault for default" do
        @status_pref.value = "default"
        @template.statusbar_style.should == "UIStatusBarStyleDefault"
      end

      it "should be UIStatusBarStyleBlackTransparent for default" do
        @status_pref.value = "black-translucent"
        @template.statusbar_style.should == "UIStatusBarStyleBlackTranslucent"
      end

      it "should be UIStatusBarStyleBlackOpaque for default" do
        @status_pref.value = "black-opaque"
        @template.statusbar_style.should == "UIStatusBarStyleBlackOpaque"
      end
    end
    
    describe "#exit_on_suspend method" do
      before do
        @config = Confetti::Config.new("#{fixture_dir}/config.xml")
        @template = @template_class.new(@config)
      end

      it "should be false with no preference" do
        @template.exit_on_suspend?.should be_false
      end

      describe "when set" do

        it "should be true for exit_on_suspend = false" do
          @status_pref = Confetti::Config::Preference.new("exit-on-suspend", "false")
          @config.preference_set << @status_pref
          @template.exit_on_suspend?.should be_true
        end

        it "should be false for exit_on_suspend = true" do
          @status_pref = Confetti::Config::Preference.new("exit-on-suspend", "true")
          @config.preference_set << @status_pref
          @template.exit_on_suspend?.should be_false
        end
      end
    end
  end
end
