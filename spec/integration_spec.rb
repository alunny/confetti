require 'spec_helper'

describe 'General usage:' do
  include HelpfulPaths

  it "should read config.xml and spit out AndroidManifest.xml" do
    output_file = "#{ fixture_dir }/AndroidManifest_output.xml"
    config = Confetti::Config.new "#{ fixture_dir }/config.xml"
    config.write_android_manifest output_file

    desired_output  = File.read "#{ fixture_dir }/AndroidManifest_expected.xml"
    actual_output   = File.read output_file
    actual_output.should == desired_output

    FileUtils.rm output_file
  end
end
