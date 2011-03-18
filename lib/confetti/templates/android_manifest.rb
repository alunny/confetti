module Confetti
  module Template
    class AndroidManifest < Base
      include JavaChecks

      GAP_PERMISSIONS_MAP = {
        "camera"        => ["CAMERA"],
        "notification"  => ["VIBRATE"],
        "geolocation"   => ["ACCESS_COARSE_LOCATION", "ACCESS_FINE_LOCATION",
            "ACCESS_LOCATION_EXTRA_COMMANDS"],
        "media"         => ["RECORD_AUDIO", "MODIFY_AUDIO_SETTINGS"],
        "contacts"      => ["READ_CONTACTS", "WRITE_CONTACTS"],
        "file"          => ["WRITE_EXTERNAL_STORAGE"],
        "network"       => ["ACCESS_NETWORK_STATE"]
      }

      def package_name
        if @config
          if is_java_package_id(@config.package)
            @config.package
          end
        end
      end

      def class_name
        convert_to_java_identifier(@config.name.name) if @config
      end

      def output_filename
        "AndroidManifest.xml"
      end

      def version
        @config.version || '0.0.1'
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

        permissions.map { |f| { :name => f } }
      end
    end
  end
end
