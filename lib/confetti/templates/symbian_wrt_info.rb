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

      def permissions
        permissions = []
        phonegap_api = /http\:\/\/api.phonegap.com\/1[.]0\/(\w+)/
        feature_names = @config.feature_set.map { |f| f.name }
        feature_names.sort

        feature_names.each do |f|
          feature_name = f.match(phonegap_api)[1] if f.match(phonegap_api)
          associated_permissions = GAP_PERMISSIONS_MAP[feature_name]
          permissions.concat(associated_permissions) if associated_permissions
        end

        permissions.sort!
        permissions.map { |f| { :name => f } }
      end
    end
  end
end
