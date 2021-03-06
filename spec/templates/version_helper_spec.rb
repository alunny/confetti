require 'spec_helper'

describe Confetti::Template::VersionHelper do
  include Confetti::Template::VersionHelper

  describe "#normalize_version" do
    it "should return str if it matches expectations" do
      normalize_version('1.8.7').should == "1.8.7"
    end

    it "should return the default (0.0.1) when str is nil" do
      normalize_version(nil).should == "0.0.1"
    end

    it "should return the default (0.0.1) when str is empty" do
      normalize_version('').should == "0.0.1"
    end

    it "should return the default if version_string isn't even close" do
      normalize_version('BBQ').should == "0.0.1"
    end

    it "should add empty digits if str has one segment" do
      normalize_version('1').should == "1.0.0"
    end

    it "should add empty digits if string has two segments" do
      normalize_version('1.1').should == "1.1.0"
    end

    it "should truncate extra digits if string has too many segments" do
      normalize_version('1.2.3.4.5').should == "1.2.3"
    end

    it "should switch letters out for numbers" do
      normalize_version('1.3.a').should == "1.3.0"
    end

    it "should remove letters when they're in there" do
      normalize_version('1.3.5a').should == "1.3.5"
    end
  end
end
