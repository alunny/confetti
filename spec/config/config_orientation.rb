require 'spec_helper'

describe Confetti::Config do

  include HelpfulPaths

  before do
    @config = Confetti::Config.new()
    @config.populate_from_xml("#{ fixture_dir }/config_with_orientation.xml")
  end

  it "Should have mode" do
    @config.orientation.value.should != "default"
  end
end