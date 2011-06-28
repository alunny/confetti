module Confetti
  module Template
    class BlackberryWidgetsConfig < Base

      def widget_id
        if @config.package.empty? or @config.package.nil?
          "com.default.noname"
        else
          @config.package
        end
      end

      def version
        if @config.version_string.empty? or @config.version_string.nil?
          "0.0.1"
        else
          @config.version_string
        end
      end

      def widget_name
        @config.name.name
      end

      def author_href
        @config.author.href
      end

      def author_email
        @config.author.email
      end

      def author_name
        @config.author.name
      end

      def widget_description
        @config.description
      end

      def license_href
        @config.license.href
      end

      def license_text
        @config.license.text
      end

      def phonegap_version
        @config.phonegap_version
      end

      def output_filename
        "config.xml"
      end

      def app_orientations

        @@landscape_orientation = ["landscape"]
        @@portrait_orientation = ["portrait"]
        @@default = ["auto"]

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
