module Confetti
  module Template
    class IosInfo < Base
      def bundle_identifier
        @config.package
      end

      def bundle_version
        @config.version
      end

      def product_name
        @config.name.name
      end

      def output_filename
        "Info.plist"
      end
    end
  end
end
