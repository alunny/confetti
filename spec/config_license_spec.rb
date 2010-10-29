require 'confetti'

describe Confetti::Config::License do
  before do
    @license = Confetti::Config::License.new
  end

  it "should have a readable and writable text field" do
    lambda { @license.text = "You can do WTF you want" }.should_not raise_error
    @license.text.should == "You can do WTF you want"
  end

  it "should have a readable and writable href field" do
    lambda { @license.href = "http://apache.org/license" }.should_not raise_error
    @license.href.should == "http://apache.org/license"
  end
end
