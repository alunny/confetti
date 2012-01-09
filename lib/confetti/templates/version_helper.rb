module Confetti
  module Template
    module VersionHelper
      class VersionError < Confetti::Error ; end

      # ensure version is in "x.x.x" format
      def normalize_version(str)
        default = "0.0.1"

        if str.nil? or str.empty?
          default
        elsif str.match /^(\d)+[.](\d)+[.](\d)+$/
          str
        elsif str.match /^((\d)+[.])*(\d)+$/
          fix_version(str)
        else
          raise VersionError, "need a valid version number of the form 0.0.0"
        end
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
