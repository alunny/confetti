module Confetti
  module Template
    class WindowsPhone7Manifest < Base
      include VersionHelper

      GAP_PERMISSIONS_MAP = {
        'camera' => %w{ID_CAP_ISV_CAMERA
                       D_HW_FRONTCAMERA},
        'contacts' => %w{ID_CAP_CONTACTS},
        'device' => %w{ID_CAP_IDENTITY_DEVICE},
        'geolocation' => %w{ID_CAP_LOCATION},
        'networking' => %w{ID_CAP_NETWORKING},
        'media' => %w{ID_CAP_MICROPHONE},
      }

      def title
        @config.name.name
      end

      def author
        @config.author.name
      end

      def guid
        guid = Digest::MD5.hexdigest @config.package 
        res = "{#{ guid[0..7] }-#{ guid[8..11] }-"
        res << "#{ guid[12..15] }-#{ guid[16..19] }-"
        res << "#{ guid[20,guid.length-1]}}"
      end

      def description
        @config.description
      end

      def version
        version = normalize_version @config.version_string
        version << ".0" 
      end

      def capabilities
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
