module Confetti
  module Template
    class IosInfo < Base

      def bundle_identifier
        @config.package
      end

      def bundle_version
        @config.version_string
      end

      def product_name
        @config.name.name
      end

      def output_filename
        "Info.plist"
      end

      def app_orientations
        
        @@landscape_orientation = ["UIInterfaceOrientationLandscapeLeft", "UIInterfaceOrientationLandscapeRight"]
        @@portrait_orientation = ["UIInterfaceOrientationPortrait", "UIInterfaceOrientationPortraitUpsideDown"]
        @@default = @@landscape_orientation | @@portrait_orientation

        @@valid_orientations = {
          "default" => @@default,
          "landscape" => @@landscape_orientation,
          "portrait" => @@portrait_orientation
        }

        super
      end

    end
  end
end
