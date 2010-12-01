require 'spec_helper'

describe 'Writing Output' do
  include HelpfulPaths
  include FileHelpers

  before do
    @config = Confetti::Config.new "#{ fixture_dir }/config.xml"
  end

  context "Android" do
    it "should read config.xml and spit out AndroidManifest.xml" do
      @output_file = "#{ fixture_dir }/AndroidManifest_output.xml"
      @config.write_android_manifest @output_file

      files_should_match @output_file, "#{ fixture_dir }/AndroidManifest_expected.xml"
    end

    it "should read config.xml and spit out strings.xml" do
      @output_file = "#{ fixture_dir }/android_strings_output.xml"
      @config.write_android_strings @output_file

      files_should_match @output_file, "#{ fixture_dir }/android_strings_expected.xml"
    end
  end

  context "webOS" do
    it "should read config.xml and spit out appinfo.json" do
      @output_file = "#{ fixture_dir }/appinfo_output.json"
      @config.write_webos_appinfo @output_file

      files_should_match @output_file, "#{ fixture_dir }/appinfo_expected.json"
    end
  end

  context "iOS" do
    it "should read config.xml and spit out Info.plist" do
      @output_file = "#{ fixture_dir }/ios_info_output.plist"
      @config.write_ios_info @output_file

      files_should_match @output_file, "#{ fixture_dir }/ios_info_expected.plist"
    end
  end

  after do
    FileUtils.rm @output_file if File.exist? @output_file
  end
end
