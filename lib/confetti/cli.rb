require "confetti"

module Confetti
  class CLI < Thor
    desc "generate OUTPUT_FILE", "Generates a config file of type OUTPUT_FILE"
    def generate(output_file)
      config_xml = File.join(Dir.pwd, "config.xml")

      config = Confetti::Config.new(config_xml)
      msg = "write_#{ output_file }".to_sym

      begin
        config.send msg
      rescue Confetti::Config::FiletypeError
        fail "Confetti failed: #{ output_file } unsupported"
      rescue Confetti::Error => e
        fail "Confetti Failed: #{ e.message }"
      end
    end
  end
end
