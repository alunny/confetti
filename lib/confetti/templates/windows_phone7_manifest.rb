module Confetti
  module Template
    class WindowsPhone7Manifest < Base
      include VersionHelper

      GAP_PERMISSIONS_MAP = {
        'camera' => %w{ID_CAP_ISV_CAMERA
                       ID_HW_FRONTCAMERA},
        'contacts' => %w{ID_CAP_CONTACTS},
        'device' => %w{ID_CAP_IDENTITY_DEVICE},
        'geolocation' => %w{ID_CAP_LOCATION},
        'network' => %w{ID_CAP_NETWORKING},
        'media' => %w{ID_CAP_MICROPHONE},
      }

      def title
        @config.name.name
      end

      def author
        @config.author.name
      end

      def guid
        package = @config.package
        package ||= 'com.example.app'
        guid = Digest::MD5.hexdigest package 
        res = "{#{ guid[0..7] }-#{ guid[8..11] }-"
        res << "#{ guid[12..15] }-#{ guid[16..19] }-"
        res << "#{ guid[20,guid.length-1]}}"
      end

      def description
        if @config.description && @config.description.length >= 250
          "#{ @config.description[0..245] }..."
        else
          @config.description
        end
      end

      def version
        v = normalize_version(@config.version_string).split('.')

        # after the first one, each segment can only have one character
        "#{ v[0] }.#{ v[1][0..0] }.#{ v[2][0..0] }.0"
      end

      def capabilities
        default_permissions = %w{camera contacts device geolocation
            network media}
        permissions = []                                                
        capabilities = []                                                
        phonegap_api = /http\:\/\/api.phonegap.com\/1[.]0\/(\w+)/          
        filtered_features = @config.feature_set.clone

        filtered_features.each { |f|
            next if f.name.nil?
            matches = f.name.match(phonegap_api)
            next if matches.nil? or matches.length < 1 
            next unless GAP_PERMISSIONS_MAP.has_key?(matches[1])
            permissions << matches[1]
        }

        if @config.feature_set.empty? and
            @config.preference(:permissions) != :none
            permissions = default_permissions
        end

        permissions.each { |p|
            capabilities.concat(GAP_PERMISSIONS_MAP[p])
        }
      
        capabilities.sort! 
        capabilities.map { |f| { :name => f } }
      end

      def output_filename 
        "WMAppManifest.xml"
      end
    end
  end
end
