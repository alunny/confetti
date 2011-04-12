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

      def version
        if @config.version_string.nil?
          '0.0.1'
        elsif @config.version_string.match /^(\d)+[.](\d)+[.](\d)+$/
          @config.version_string
        elsif @config.version_string.match /^((\d)+[.])*(\d)+$/
          fix_version(@config.version_string)
        else
          fail "need a valid version number of the form 0.0.0"
        end
      end

      def vendor
        @config.author.name
      end

      private
        def fix_version(str)
          segments = str.split('.')

          segments << '0' if segments.length == 1
          segments << '0' if segments.length == 2

          segments[0,3].join '.'
        end
    end
  end
end
