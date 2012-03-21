require 'spec_helper'

describe Confetti::Template::WindowsPhone7Manifest do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::WindowsPhone7Manifest
  end

  it "should have the base class of Confetti::Template" do
    @template_class.superclass.should == Confetti::Template::Base
  end

  it "should have a valid WMAppManifest mustace template" do
    @template_class.template_file.should == "#{ templates_dir }/windows_phone7_manifest.mustache"
  end

  describe "attributes" do
    subject { @template = @template_class.new }
    
    it { should respond_to :title }
    it { should respond_to :author }
    it { should respond_to :guid }
    it { should respond_to :description }
    it { should respond_to :version }
    it { should respond_to :capabilities }
  end

  it "should provide a 128 bit guid" do
    @config = Confetti::Config.new
    @config.package = "com.example.www"
    @template = @template_class.new @config
    @template.guid.should == "{1005a3fc-23ab-99bd-bdd1-9e83f3d7b989}" 
  end

  describe "with a config object" do

    before do
      @config = Confetti::Config.new "#{fixture_dir}/config.xml"
    end

    it "should render" do
      @template = @template_class.new @config 
      @template.render.should == File.read(
          "#{fixture_dir}/windowsphone7/WMAppManifest.xml"
        )
    end
  end
end
