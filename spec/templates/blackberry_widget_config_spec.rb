require 'spec_helper'

describe Confetti::Template::BlackberryWidgetsConfig do
  include HelpfulPaths

  before :all do
    @template_class = Confetti::Template::BlackberryWidgetsConfig
  end

  it "should inherit from the base template" do
    @template_class.superclass.should be Confetti::Template::Base
  end

  it "should have the template_file \"blackberry_widgets_config.mustache\" in the confetti/templates dir" do
    @template_class.template_file.should == "#{ templates_dir }/blackberry_widgets_config.mustache"
  end

  describe "templated attributes" do
    subject { @template = @template_class.new }

    it { should respond_to :widget_id }
    it { should respond_to :widget_name }
    it { should respond_to :author_name }
    it { should respond_to :author_email }
    it { should respond_to :author_href }
    it { should respond_to :widget_description }
    it { should respond_to :license_text }
    it { should respond_to :license_href }
  end

  describe "default values" do
    it "should define output filename as \"config.xml\"" do
      @template_class.new.output_filename.should == "config.xml"
    end
  end

  describe "when passed a config object" do
    before do
      @config = Confetti::Config.new
      @config.name.name = "Awesome App"
      @config.package = "com.whoever.awesome.app"
      @config.version_string = "1.0.0"
      @config.author.name = "Bruce Lee"
      @config.author.email = "blee@hotmail.com"
      @config.author.href = "http://brucelee.cn"
      @config.description = "My New App, by Bruce Lee"
    end

    it "should accept the config object" do
      lambda {
        @template_class.new(@config)
      }.should_not raise_error
    end

    describe "templated attributes" do
      before do
        @template = @template_class.new(@config)
      end

      it "should set identifier correctly" do
        @template.widget_id.should == "com.whoever.awesome.app"
      end

      it "should set display_name correctly" do
        @template.widget_name.should == "Awesome App"
      end

      it "should set description correctly" do
        @template.widget_description.should == "My New App, by Bruce Lee"
      end

      describe "author" do
        it "should set name correctly" do
          @template.author_name.should == "Bruce Lee"
        end

        it "should set href correctly" do
          @template.author_href.should == "http://brucelee.cn"
        end

        it "should set email correctly" do
          @template.author_email.should == "blee@hotmail.com"
        end
      end

      it "should render the correct config.xml" do
        @template.render.should == File.read("#{ fixture_dir }/blackberry_widget_config_spec.xml")
      end
    end
  end
end
