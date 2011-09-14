module Confetti
  module Template
    class SymbianWrtInfo < Base

      GAP_PERMISSIONS_MAP = {
        "network"       => %w{AllowNetworkAccess},
      }

      def identifier
        @config.package
      end

      def version
        if @config.version_string.nil? or @config.version_string.empty?      
          "1.0"
        else
          @config.version_string
        end
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
