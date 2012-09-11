module Confetti
  module Template
    class WebosAppinfo < Base
      include JavaChecks
      include VersionHelper

      def app_id
        pkg = convert_to_java_package_id(@config.package).downcase
        pkg.gsub(/[^0-9a-z.]/,'')
      end

      def app_name
        @config.name.name
      end

      def output_filename
        "appinfo.json"
      end

      def version
        normalize_version(@config.version_string)
      end

      def vendor
        @config.author.name
      end

      def tablet_support?
        true unless @config.preference("target-device")
      end
    end
  end
end
