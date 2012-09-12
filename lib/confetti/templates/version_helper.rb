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
          extend_version(str)
        elsif str.match /^([\d\w]+)[.]([\d\w]+)[.]([\d\w]+)$/
          deletter_version(str)
        else
          raise VersionError, "need a valid version number of the form 0.0.0"
        end
      end

      private
        def extend_version(str)
          segments = str.split('.')

          segments << '0' if segments.length == 1
          segments << '0' if segments.length == 2

          segments[0,3].join '.'
        end

        def deletter_version(str)
          segments = str.split('.')
          new_parts = []

          segments.each do |seg|
            unless /^\d+$/ =~ seg
              seg.gsub!(/[^\d]/, '')
              seg = '0' if seg.length == 0
            end

            new_parts << seg
          end

          new_parts.join '.'
        end
    end
  end
end
