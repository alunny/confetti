require "confetti"

module Confetti
  class CLI < Thor
    desc "generate OUTPUT_FILE", "Generates a config file of type OUTPUT_FILE"
    def generate(output_file)
      puts Dir.pwd
      # find config.xml in the current directory
      # read config.xml
      # write out android_(whatever) to current directory
    end
  end
end
