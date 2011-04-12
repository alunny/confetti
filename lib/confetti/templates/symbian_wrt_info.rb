module Confetti
  module Template
    class SymbianWrtInfo < Base
      def identifier
        @config.package
      end

      def version
        @config.version_string
      end

      def display_name
        @config.name.name
      end

      def output_filename
        "info.plist"
      end
    end
  end
end
