require 'spec_helper'

describe Confetti::CLI do
  include HelpfulPaths

  describe "generate method" do
    before do
      Dir.stub(:pwd).and_return(fixture_dir)
      @cli = Confetti::CLI.new
      Confetti::Config.any_instance.stub(:open)
    end

    describe "with a correct ouput file" do
      it "should not raise an error" do
        lambda { @cli.generate "android_manifest" }.should_not raise_error
      end
    end

    describe "with an unsupported output file" do
      it "should raise the correct error" do
        lambda { 
          @cli.generate "mgm_dvd"
        }.should raise_error RuntimeError,
                            "Confetti failed: mgm_dvd unsupported"
      end
    end
  end
end
