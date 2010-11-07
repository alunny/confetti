require 'spec_helper'

describe 'General usage:' do
  include HelpfulPaths

  it "should read config.xml and spit out AndroidManifest.xml" do
    config = Confetti::Config.new "#{ fixture_dir }/config.xml"
    config.write_for_android "#{ fixture_dir }/AndroidManifest_output.xml"

    desired_output  = File.read "#{ fixture_dir }/AndroidManifest_expected.xml"
    actual_output   = File.read "#{ fixture_dir }/AndroidManifest_output.xml"
    actual_output.should == desired_output
  end
end
