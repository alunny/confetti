module Confetti
  module Template
    class AndroidManifest < Base
      def package_name
        # must be valid Java identifier
        #
        # should be [A-Za-z0-9_]
        # (java identifiers can have $, but don't do that)
        # should be dot separated
      end

      def class_name
        # must be valid Java identifier
      end
    end
  end
end
