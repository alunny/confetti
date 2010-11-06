require 'confetti'

describe 'General usage:' do
  it "should read config.xml and spit out AndroidManifest.xml" do
    config_the_first = Confetti::Config.new "fixtures/config_the_first.xml"
    config_the_first.write_for_android "fixtures/android_manifest_first.xml"

    desired_output = File.read "fixtures/android_the_first.xml"
    actual_output = File.read "fixtures/android_manifest_first.xml"
    actual_output.should == desired_output
  end
end
