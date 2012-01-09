module Confetti
  module Template
    class WebosAppinfo < Base
      include JavaChecks
      include VersionHelper

      def app_id
        if @config
          if is_java_package_id(@config.package)
            @config.package
          end
        end
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
    end
  end
end
