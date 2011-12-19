require 'spec_helper'

describe 'Writing Output' do
  include HelpfulPaths
  include FileHelpers

  before do
    @config = Confetti::Config.new "#{ fixture_dir }/config.xml"
  end

  context "Android" do
    it "should read config.xml and spit out AndroidManifest.xml" do
      @output_file = "#{ fixture_dir }/android/AndroidManifest_output.xml"
      @config.write_android_manifest @output_file

      files_should_match @output_file, "#{ fixture_dir }/android/AndroidManifest_expected.xml"
    end

    it "should read config.xml and spit out strings.xml" do
      @output_file = "#{ fixture_dir }/android/android_strings_output.xml"
      @config.write_android_strings @output_file

      files_should_match @output_file, "#{ fixture_dir }/android/android_strings_expected.xml"
    end
  end

  context "webOS" do
    it "should read config.xml and spit out appinfo.json" do
      @output_file = "#{ fixture_dir }/webos/appinfo_output.json"
      @config.write_webos_appinfo @output_file

      files_should_match @output_file, "#{ fixture_dir }/webos/appinfo_expected.json"
    end
  end

  context "iOS" do
    it "should read config.xml and spit out Info.plist" do
      @output_file = "#{ fixture_dir }/ios/ios_info_output.plist"
      @config.write_ios_info @output_file

      files_should_match @output_file, "#{ fixture_dir }/ios/ios_info_expected.plist"
    end
  end

  context "Symbian.wrt" do
    it "should read config.xml and spit out info.plist" do
      @output_file = "#{ fixture_dir }/symbian/symbian_wrt_info_output.plist"
      @config.write_symbian_wrt_info @output_file

      files_should_match @output_file, "#{ fixture_dir }/symbian/symbian_wrt_info_expected.plist"
    end
  end

  context "Blackberry Widgets" do
    describe "legacy Phonegap" do
      before do
        @config = Confetti::Config.new "#{ fixture_dir }/config_legacy.xml"
      end

      it "should read config.xml and spit out config.xml" do
        @output_file = "#{ fixture_dir }/blackberry/blackberry_widget_config_output.xml"
        @config.write_blackberry_widgets_config @output_file

        files_should_match @output_file,
          "#{ fixture_dir }/blackberry/blackberry_widget_config_legacy_expected.xml"
      end
    end

    describe "current (>= 1.3.0) Phonegap" do
      it "should read config.xml and spit out config.xml" do
        @output_file = "#{ fixture_dir }/blackberry/blackberry_widget_config_output.xml"
        @config.write_blackberry_widgets_config @output_file

        files_should_match @output_file,
          "#{ fixture_dir }/blackberry/blackberry_widget_config_expected.xml"
      end
    end
  end

  after do
    FileUtils.rm @output_file if File.exist? @output_file
  end
end
