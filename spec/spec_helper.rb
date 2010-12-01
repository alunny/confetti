require "confetti"

module HelpfulPaths
  SPEC_DIR         = File.dirname(__FILE__)
  FIXTURE_DIR      = SPEC_DIR + "/fixtures"
  TEMPLATES_DIR    = File.expand_path "../lib/confetti/templates", SPEC_DIR

  def fixture_dir
    FIXTURE_DIR
  end

  def templates_dir
    TEMPLATES_DIR
  end
end

module FileHelpers
  def files_should_match(file_one, file_two = nil)
    File.read(file_one).should == File.read(file_two)
  end
end

module ConfigHelpers
  def self.included(base)
    base.extend(WriteAndGenerateMacros)
  end

  module WriteAndGenerateMacros
    generate_write_spec = "it_should_have_generate_and_write_methods_for"

    send :define_method, generate_write_spec do |config_type|
      class_name = config_type.to_s.split("_").collect do |s|
        s.capitalize
      end.join
      template_class = Confetti::Template.const_get(class_name)
      default_filename = template_class.new.output_filename

      generate_method = "generate_#{ config_type }".to_sym
      write_method = "write_#{ config_type }".to_sym

      describe config_type do
        before do
          @config.package = "com.whoever.awesome.app"
          @config.name.name = "Awesome App"
        end

        describe "#generate_#{ config_type }" do
          it "should create a new #{ class_name } template" do
            @config.send(generate_method).should be_a template_class
          end
        end

        describe "#write_#{ config_type }" do
          before do
            @contents = "foo"
            @template = template_class.new
            @output = mock(IO)

            @config.should_receive(generate_method).and_return(@template)
            @template.should_receive(:render).and_return(@contents)
            @output.should_receive(:puts).with(@contents)
          end

          it "should write the rendered #{ default_filename } to the fs" do
            filepath = "my_directory/#{ default_filename }"
            @config.should_receive(:open).with(filepath, 'w').and_yield(@output)

            @config.send(write_method, filepath)
          end

          describe "when no filepath is passed" do
            it "should write the rendered #{ default_filename } to the default location" do
              default_path = File.join(Dir.pwd, default_filename)
              @config.should_receive(:open).with(default_path, 'w').and_yield(@output)

              @config.send(write_method)
            end
          end
        end
      end
    end
  end
end
