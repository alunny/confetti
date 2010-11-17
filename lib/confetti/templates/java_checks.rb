module Confetti
  module Template
    module JavaChecks
      def is_java_identifier(str)
        str.match(/^[a-zA-z_][a-zA-z0-9_]*$/)
      end
    end
  end
end
