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
end
