require "spec_helper"

describe Confetti::Helpers do
  include Confetti::Helpers

  describe "#is_file?" do
    it "should call File.exist? for the passed argument" do
      File.should_receive(:exist?).with("foo.txt")

      is_file? "foo.txt"
    end

    it "should return the same result as File.exist? does" do
      File.should_receive(:exist?).with("foo.txt").and_return(true)
      is_file?("foo.txt").should be_true

      File.should_receive(:exist?).with("foo.txt").and_return(false)
      is_file?("foo.txt").should be_false
    end
  end
end
