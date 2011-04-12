module Confetti
  module Template
    class BlackberryWidgetsConfig < Base
      def widget_id
        @config.package
      end

      def version
        @config.version_string || "0.0.1"
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

      def output_filename
        "config.xml"
      end
    end
  end
end
