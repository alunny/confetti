require 'spec_helper'

describe Confetti::Config do
  include ConfigHelpers
  include HelpfulPaths

  before do
    @config = Confetti::Config.new
  end

  describe "fields on the widget element" do
    it "has a writable and readable package field" do
      lambda { @config.package = "com.alunny.greatapp" }.should_not raise_error
      @config.package.should == "com.alunny.greatapp"
    end

    it "has a writable and readable version_string field" do
      lambda { @config.version_string = "0.1.0" }.should_not raise_error
      @config.version_string.should == "0.1.0"
    end

    it "has a writable and readable version_code field" do
      lambda { @config.version_code = 12 }.should_not raise_error
      @config.version_code.should == 12
    end

    it "has a writable and readable height field" do
      lambda { @config.height = 500 }.should_not raise_error
      @config.height.should == 500
    end

    it "has a writable and readable width field" do
      lambda { @config.width = 500 }.should_not raise_error
      @config.width.should == 500
    end

    it "has a list of viewmodes" do
      @config.viewmodes.should be_an Array
    end

    it "should let viewmodes be appended" do
      @config.viewmodes << "windowed"
      @config.viewmodes << "floating"
      @config.viewmodes.should == ["windowed","floating"]
    end

    it "has a writable and readable description field" do
      lambda { @config.description = "A Great App That Lets You Do Things" }.should_not raise_error
      @config.description.should == "A Great App That Lets You Do Things"
    end
  end

  describe "widget child elements (zero or one, per locale)" do
    it "has a name field, that is a name object" do
      @config.name.should be_a Confetti::Config::Name
    end

    it "doesn't allow name to be clobbered" do
      lambda { @config.name = "Stellar Game" }.should raise_error
    end

    it "has an author field, that is an author object" do
      @config.author.should be_a Confetti::Config::Author
    end

    it "doesn't allow author to be clobbered" do
      lambda { @config.author = "Andrew Lunny" }.should raise_error
    end

    it "has a license field, that is a license object" do
      @config.license.should be_a Confetti::Config::License
    end

    it "doesn't allow license to be clobbered" do
      lambda { @config.license = "MIT" }.should raise_error
    end

    it "has a content field, that is a content object" do
      @config.content.should be_a Confetti::Config::Content
    end

    it "doesn't allow content to be clobbered" do
      lambda { @config.content = "foo.html" }.should raise_error
    end
  end

  describe "widget child elements (zero or more)" do
    it "has an icon_set field, that is a TypedSet" do
      @config.icon_set.should be_a TypedSet
    end

    it "icon_set should be typed to Image objects" do
      @config.icon_set.set_class.should be Confetti::Config::Image
    end

    it "should not allow icon_set to be clobbered" do
      lambda { 
        @config.icon_set = ['icon.png', 'icon-hires.png']
      }.should raise_error
    end

    it "has an feature_set field, that is a TypedSet" do
      @config.feature_set.should be_a TypedSet
    end

    it "feature_set should be typed to feature objects" do
      @config.feature_set.set_class.should be Confetti::Config::Feature
    end

    it "should not allow feature_set to be clobbered" do
      lambda { 
        @config.feature_set = ['Geolocation', 'Acceleration']
      }.should raise_error
    end

    it "has an preference_set field, that is a TypedSet" do
      @config.preference_set.should be_a TypedSet
    end

    it "preference_set should be typed to preference objects" do
      @config.preference_set.set_class.should be Confetti::Config::Preference
    end

    it "should not allow preference_set to be clobbered" do
      lambda { 
        @config.preference_set = { 
          'Autorotate' => false, 
          'Notification' => 'silent'
        }
      }.should raise_error
    end
  end

  describe "#initialize with file" do
    before do
      # pretty gross rspec
      @blank_config = Confetti::Config.new
    end

    it "should not call #is_file? if no arguments are passed" do
      @blank_config.should_not_receive(:is_file?)
      @blank_config.send :initialize
    end

    it "should call #is_file? with an argument passed" do
      @blank_config.should_receive(:is_file?)
      @blank_config.send :initialize, "config.xml"
    end

    it "should call #populate_from_xml with a file passed" do
      @blank_config.stub(:is_file?).and_return(true)
      @blank_config.should_receive(:populate_from_xml).with("config.xml")
      @blank_config.send :initialize, "config.xml"
    end
  end

  describe "#populate_from_xml" do
    it "should try to read the passed filename" do
      File.should_receive(:read).with("config.xml")
      lambda {
        @config.populate_from_xml "config.xml"
      }.should raise_error
    end

    it "should raise an error if the file doesn't exist" do
      lambda {
        @config.populate_from_xml("foo.goo")
      }.should raise_error Confetti::Config::FileError
    end

    it "should raise an error with malformed xml" do
      lambda {
        @config.populate_from_xml("#{ fixture_dir }/bad_config.xml")
      }.should raise_error Confetti::Config::XMLError
    end

    it "should raise an error if no root node is found" do
      File.stub(:read).and_return(nil)
      lambda {
        @config.populate_from_xml("#{ fixture_dir }/empty_non_existent.xml")
      }.should raise_error Confetti::Config::XMLError
    end

    describe "when setting attributes from config.xml" do
      before do
        @config.populate_from_xml(fixture_dir + "/config.xml")
      end

      describe "that has empty tags" do
        before do
          @config.populate_from_xml(fixture_dir + "/empty_elements.xml")
        end

        it "should set the author to the empty string" do
          @config.author.name.should == ""
        end

        it "should set the name to the empty string" do
          @config.name.name.should == ""
        end

        it "should set the description to the empty string" do
          @config.description.should == ""
        end

        it "should set the license to the empty string" do
          @config.license.text.should == ""
        end

      end

      it "should keep a reference to the xml doc" do
        @config.xml_doc.should_not == nil
        @config.xml_doc.class.should == REXML::Element
      end

      it "should populate the app's package when present" do
        @config.package.should == "com.alunny.confetti"
      end

      it "should populate the app's name when present" do
        @config.name.name.should == "Confetti Sample App"
      end

      it "should populate the app's version_string when present" do
        @config.version_string.should == "1.0.0"
      end

      it "should populate the app's description when present" do
        desc = "This is a sample config.xml for integration testing with Confetti"
        @config.description.should == desc
      end

      describe "widget Author" do
        it "should populate the author's name" do
          @config.author.name.should == "Andrew Lunny"
        end

        it "should populate the author's href (url)" do
          @config.author.href.should == "http://alunny.github.com"
        end

        it "should populate the author's email" do
          @config.author.email.should == "alunny@gmail.com"
        end
      end

      describe "splash screens" do
        it "should append splash screens to the splash_set" do
          @config.splash_set.size.should be 1
        end
        
        it "should set the splash screen's src correctly" do
          @config.splash_set.first.src.should == "mainsplash.png"
        end

        it "should set the splash screen's height correctly" do
          @config.splash_set.first.height.should == "480"
        end

        it "should set the splash screen's width correctly" do
          @config.splash_set.first.width.should == "360"
        end

        describe "with custom splash screen attributes" do
          before do
            @config = Confetti::Config.new
            @config.populate_from_xml(
              fixture_dir + "/config-icons-custom-attribs.xml"
              )
          end

          it "should populate splash screen non-standards attributes to extras field" do
            @config.splash_set.size.should be 1
            @config.splash_set.first.extras.should_not == nil
            @config.splash_set.first.extras.length.should be 1
            @config.splash_set.first.extras["main"].should == "true"
          end
        end

        describe "with a blank splash screen attribute" do
          before do
            @config = Confetti::Config.new
            @config.populate_from_xml(fixture_dir + "/configs/blank-splash.xml")
          end

          it "should not populate the splash set" do
            @config.splash_set.should be_empty
          end
        end
      end

      describe "icons" do
        it "should append icons to the icon_set" do
          @config.icon_set.size.should be 1
        end

        it "should set the icon's src correctly" do
          @config.icon_set.first.src.should == "icon.png"
        end

        it "should set the icon's height correctly" do
          @config.icon_set.first.height.should == "150"
        end

        it "should set the icon's width correctly" do
          @config.icon_set.first.width.should == "200"
        end

        describe "with multiple icons" do
          before do
            @config = Confetti::Config.new
            @config.populate_from_xml(fixture_dir + "/config-icons.xml")
          end

          it "should populate all of the icon_set" do
            @config.icon_set.size.should be 2
          end
        end

        describe "with custom icon attributes" do
          before do
            @config = Confetti::Config.new
            @config.populate_from_xml(fixture_dir + "/config-icons-custom-attribs.xml")
          end

          it "should populate icon non-standards attributes to extras field" do
            @config.icon_set.size.should be 1
            @config.icon_set.first.extras.should_not == nil
            @config.icon_set.first.extras.length.should be 1
            @config.icon_set.first.extras["hover"].should == "true"
          end

        end
      end

      describe "features" do
        it "should append features to the feature set" do
          @config.feature_set.size.should be 3
        end

        it "should include the right features" do
          # first tends to be last listed in xml document
          features_names = @config.feature_set.map { |f| f.name }
          features_names.should include "http://api.phonegap.com/1.0/geolocation"
          features_names.should include "http://api.phonegap.com/1.0/camera"
          features_names.should include "http://api.phonegap.com/1.0/notification"
        end
      end

      describe "access" do
        before do
          @config = Confetti::Config.new
          @config.populate_from_xml(fixture_dir + "/config_with_access.xml")
        end

        it "should append tags to the access set" do
          @config.access_set.size.should be 2
        end

        describe "created access object" do
          before do
            @bar = @config.access_set.detect do |a|
              a.origin == "http://bar.phonegap.com"
            end
            @foo = @config.access_set.detect do |a|
              a.origin == "http://foo.phonegap.com"
            end
          end

          it "should read the origins correctly" do
            @foo.should be_true
            @bar.should be_true # truthy (should exist)
          end

          it "should default subdomains to true" do
            @foo.subdomains.should be_true
          end

          it "should allow subdomains to be set to false" do
            @bar.subdomains.should be_false
          end
        end
      end
    end
  end

  describe "config generation" do
    it_should_have_generate_and_write_methods_for :android_manifest

    it_should_have_generate_and_write_methods_for :android_strings

    it_should_have_generate_and_write_methods_for :webos_appinfo

    it_should_have_generate_and_write_methods_for :ios_info

    it_should_have_generate_and_write_methods_for :symbian_wrt_info

    it_should_have_generate_and_write_methods_for :blackberry_widgets_config

    it_should_have_generate_and_write_methods_for :windows_phone7_manifest
  end

  describe "icon helpers" do
    describe "if no icon has been set" do
      it "#icon should return nil" do
        @config.icon.should be_nil
      end

      it "#biggest_icon should return nil" do
        @config.biggest_icon.should be_nil
      end
    end

    describe "with a single icon" do
      before do
        @config = Confetti::Config.new(fixture_dir + "/config.xml")
      end

      it "#icon should return an Image" do
        @config.icon.should be_a Confetti::Config::Image
      end

      it "#biggest_icon should return an Image" do
        @config.biggest_icon.should be_a Confetti::Config::Image
      end
    end

    describe "with multiple icons" do
      before do
        @config.populate_from_xml(fixture_dir + "/config-icons.xml")
      end

      it "#icon should return a single Image" do
        @config.icon.should be_a Confetti::Config::Image
      end

      it "#biggest_icon should return the bigger of the two" do
        @config.biggest_icon.src.should == "bigicon.png"
      end
    end
  end

  describe "splash helpers" do
    describe "if no splash screen has been set" do
      it "#splash should return nil" do
        @config.splash.should be_nil
      end
    end

    describe "with a single splash screen" do # config.xml
      it "#splash should return an Image" do
        @config.populate_from_xml "#{ fixture_dir }/config.xml"
        @config.splash.should be_a Confetti::Config::Image
      end
    end
  end

  describe "orientation helper" do
    it "should be :default with none set" do
      c = Confetti::Config.new
      c.orientation.should be :default
    end

    describe "with an orientation preference" do
      before do
        @config = Confetti::Config.new
        @orientation_pref = Confetti::Config::Preference.new "orientation"
        @config.preference_set << @orientation_pref
      end

      it "should be :default when no value is set" do
        @config.orientation.should be :default
      end

      it "should be :landscape when the value is 'landscape'" do
        @orientation_pref.value = "landscape"
        @config.orientation.should be :landscape
      end

      it "should be :portrait when the value is 'portrait'" do
        @orientation_pref.value = "portrait"
        @config.orientation.should be :portrait
      end

      it "should be :default when the value is unexpected" do
        @orientation_pref.value = "topwise"
        @config.orientation.should be :default
      end
    end
  end

  describe "preference accessor" do
    before do
      @config = Confetti::Config.new
      @pref = Confetti::Config::Preference.new "permissions", "none"
      @config.preference_set << @pref
    end

    it "should return the value of the specified preference" do
      @config.preference(:permissions).should == :none
    end

    it "should be nil when the preference is not set" do
      @config.preference(:size).should be_nil
    end

    it "should be nil when the preference has no value" do
      pref = Confetti::Config::Preference.new "privacy"
      @config.preference_set << pref

      @config.preference(:privacy).should be_nil
    end
  end

  describe "full_access?" do
    before do
      @config = Confetti::Config.new
    end

    it "should be false with an empty access set" do
      @config.full_access?.should be_false
    end

    it "should be true when origin='*' is in there" do
      @config.access_set << Confetti::Config::Access.new('*')
      @config.full_access?.should be_true
    end

    it "should be false with only other origins" do
      @config.access_set << Confetti::Config::Access.new('http://mysite.com')
      @config.access_set << Confetti::Config::Access.new('http://myothersite.com')
      @config.full_access?.should be_false
    end
  end

  describe "platform and roll helpers" do
    before do
      file = "#{fixture_dir}/config-icons-custom-attribs-extended.xml"
      @config = Confetti::Config.new file 
    end

    it "should return all blackberry icons with hover" do
      match = @config.platform_assets(
          @config.send(:icon_set),
          { 
            'platform' => 'blackberry',
            'role' => 'hover'
          }
        )
      match.length.should == 1
      match.first.src.should == 'icons/icon_hover.png'
    end

    it "should return all icons" do
      match = @config.platform_assets(@config.send(:icon_set),{})
      match.length.should == 11
    end

    it "should find the best fit image for bb" do
      match = @config.find_best_fit_img(
        @config.send(:icon_set),
        {
          'platform' => 'blackberry',
          'role' => 'hover'
        }
      )
      match.src.should == "icons/icon_hover.png"
    end

    it "should find the best fit icon for winphone" do
      # we will find a 68pixel image as it fits out platform
      # specification
      match = @config.find_best_fit_img(
        @config.send(:icon_set),
        {
          'height' => '54',
          'width' => '54',
          'platform' => 'winphone',
          'role' => 'default'
        }
      )
      match.src.should == "icons/icon-68.png"
    end

    it "should find the best fit splash for android" do
      # we will find a 68pixel image as it fits out platform
      # specification
      match = @config.find_best_fit_img(
        @config.send(:splash_set),
        {
          'height' => '54',
          'width' => '54',
          'platform' => 'android',
          'role' => 'default'
        }
      )
      match.src.should == "splashes/splash-android.png"
    end

    it "should return the default icon: icon.png" do
      @config.default_icon.src.should == "icons/icon.png"
    end

    it "should fail to return the default icon: icon.png" do
      @config = Confetti::Config.new
      @config.default_icon.should != nil 
    end

    it "should return the default splash: splash.png" do
      @config.default_splash.src.should == "splashes/splash.png"
    end

    it "should fail to return the default splash: splash.png" do
      @config = Confetti::Config.new
      @config.default_splash.should != nil 
    end
  end
end
