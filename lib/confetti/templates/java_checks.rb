module Confetti
  module Template
    module JavaChecks
      def is_java_identifier(str)
        str.match(/^[a-zA-Z_][a-zA-Z0-9_]*$/)
      end

      def convert_to_java_identifier(str)
        str.sub(/^\d/,"_").gsub(/[^a-zA-Z0-9_]/,"_")
      end

      def is_java_package_id(str)
        # second param to #split ensures can't be dot-terminated
        str.split('.', -1).all? { |s| is_java_identifier(s) }
      end
    end
  end
end
