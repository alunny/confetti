require 'confetti'

FIXTURE_DIR = File.dirname(__FILE__) + "/fixtures"

describe 'General usage:' do
  it "should read config.xml and spit out AndroidManifest.xml" do
    config = Confetti::Config.new "#{ FIXTURE_DIR }/config.xml"
    config.write_for_android "#{ FIXTURE_DIR }/AndroidManifest_output.xml"

    desired_output  = File.read "#{ FIXTURE_DIR }/AndroidManifest_expected.xml"
    actual_output   = File.read "#{ FIXTURE_DIR }/AndroidManifest_output.xml"
    actual_output.should == desired_output
  end
end
