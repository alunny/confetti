require "spec_helper"

class PhoneGapSpec
  include Confetti::PhoneGap

  attr_accessor :feature_set

  def initialize
    @feature_set = []
  end
end

describe Confetti::PhoneGap do
  before do
    @obj = PhoneGapSpec.new
  end

  describe "#add_stock_phonegap_apis" do
    it "should access the object's feature_set" do
      @obj.should_receive(:feature_set).at_least(:once).and_return([])

      @obj.add_stock_phonegap_apis
    end

    it "should add one feature for every PhoneGap API" do
      count = Confetti::PhoneGap::PHONEGAP_APIS.length
      @obj.feature_set.should_receive(:<<).exactly(count).times

      @obj.add_stock_phonegap_apis
    end
  end

  describe "#legacy_plugins" do
    before do
      @obj.feature_set = []
      childbrowser  = "http://plugins.phonegap.com/ChildBrowser/1.0.1"
      fbconnect     = "http://plugins.phonegap.com/FBConnect/1.2.1/"
      file_api      = "http://api.phonegap.com/1.0/file"

      @obj.feature_set << Confetti::Config::Feature.new(childbrowser, nil)
      @obj.feature_set << Confetti::Config::Feature.new(fbconnect, nil)
      @obj.feature_set << Confetti::Config::Feature.new(file_api, nil)
      @obj.feature_set << Confetti::Config::Feature.new(nil, nil)
    end

    it "should return an array with 2 entries" do
      @obj.legacy_plugins.length.should be 2
    end

    it "should return an array with 2 Plugin objects" do
      @obj.legacy_plugins.first.should be_a Confetti::PhoneGap::Plugin
      @obj.legacy_plugins.last.should be_a Confetti::PhoneGap::Plugin
    end

    it "should return the right data as plugins" do
      childbrowser = @obj.legacy_plugins.first
      fbconnect = @obj.legacy_plugins.last

      childbrowser.name.should == "ChildBrowser"
      childbrowser.version.should == "1.0.1"

      fbconnect.name.should == "FBConnect"
      fbconnect.version.should == "1.2.1"
    end
  end
end
