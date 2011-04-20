module Confetti
  module Template
    module JavaChecks
      def is_java_identifier(str)
        str.match(/^[a-zA-Z_][a-zA-Z0-9_]*$/)
      end

      def convert_to_java_identifier(str)
        str.sub(/^\d/,"_").gsub(/\s/,"").gsub(/[^a-zA-Z0-9_]/,"_")
      end

      def is_java_package_id(str)
        components = str.split('.', -1)

        # second param to #split ensures can't be dot-terminated
        components.length > 1 and components.all? { |s| is_java_identifier(s) }
      end
    end
  end
end
