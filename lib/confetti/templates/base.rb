module Confetti
  module Template
    class Base < Mustache

      @@landscape_orientation = []
      @@portrait_orientation = []
      @@default = []
      @@valid_orientations = []

      self.template_path = File.dirname(__FILE__)

      def initialize (*args)
        @config = args.pop

        super *args
      end

      def app_orientations
        if @config.orientation.nil? or @@valid_orientations[@config.orientation.value].nil?
          @@valid_orientations["default"]
        else
          @@valid_orientations[@config.orientation.value]
        end
      end

    end
  end
end
