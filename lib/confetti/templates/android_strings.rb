module Confetti
  module Template
    class AndroidStrings < Base
      def app_name
        @config.name.name if @config && @config.name
      end

      def output_filename
        "strings.xml"
      end
    end
  end
end
