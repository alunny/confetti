module Confetti
  module Template
    class WebosAppinfo < Base
      include JavaChecks

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
    end
  end
end
