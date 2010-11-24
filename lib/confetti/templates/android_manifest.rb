module Confetti
  module Template
    class AndroidManifest < Base
      include JavaChecks

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
    end
  end
end
