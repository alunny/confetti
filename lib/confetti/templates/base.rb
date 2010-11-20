module Confetti
  module Template
    class Base < Mustache
      self.template_path = File.dirname(__FILE__)

      def initialize (*args)
        @config = args.pop

        super *args
      end
    end
  end
end
