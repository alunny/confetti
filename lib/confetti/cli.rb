require "confetti"

module Confetti
  class CLI < Thor
    desc "generate OUTPUT_FILE", "Generates a config file of type OUTPUT_FILE"
    def generate(output_file)
      config_xml = File.join(Dir.pwd, "config.xml")
      output_name = File.join(Dir.pwd, "AndroidManifest.xml")

      config = Confetti::Config.new(config_xml)
      config.write_android_manifest(output_name)
    end
  end
end
