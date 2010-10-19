require 'confetti'

describe Confetti::Config do
  before do
    @config = Confetti::Config.new
  end

  it "has a writable and readable name field" do
    @config.name = "My Great App"
    @config.name.should be "My Great App"
  end

end
