require 'confetti'

describe Confetti::Config do
  before do
    @config = Confetti::Config.new
  end

  describe "fields on the widget element" do
    it "has a writable and readable package field" do
      lambda { @config.package = "com.alunny.greatapp" }.should_not raise_error
      @config.package.should == "com.alunny.greatapp"
    end

    it "has a writable and readable version field" do
      lambda { @config.version = "0.1.0" }.should_not raise_error
      @config.version.should == "0.1.0"
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

    it "icon_set should be typed to icon objects" do
      @config.icon_set.set_class.should be Confetti::Config::Icon
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

  describe " - platform generation" do
    describe "Android" do
      it "should read in the Android template"

      it "should return an Android config string"
    end
  end

  describe " - platform writing" do
    describe "Android"
  end
end
