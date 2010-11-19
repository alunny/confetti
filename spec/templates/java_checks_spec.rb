require 'spec_helper'

describe Confetti::Template::JavaChecks do
  include Confetti::Template::JavaChecks

  describe "#is_java_identifier" do
    describe "should fail when" do
      it "has invalid characters" do
        is_java_identifier("ooo:bu").should be_false
      end

      it "begins with a number" do
        is_java_identifier("12Class").should be_false
      end
    end

    describe "should succeed when" do
      it "valid characters are passed" do
        is_java_identifier("ClassName").should be_true
      end
    end
  end

  describe "#convert_to_java_identifier" do
    it "should not affect a valid identifier"

    it "should convert all invalid characters to underscores"
  end
end
