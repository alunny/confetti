require 'confetti'

describe Confetti::Template::Android do
  it "should inherit from the base template" do
    Confetti::Template::Android.superclass.should be Confetti::Template::Base
  end
end
