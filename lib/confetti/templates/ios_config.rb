module Confetti
  module Template
    class IosConfig < IosInfo

      def icons
        flat_array super
      end

      def app_orientations
        flat_array super
      end

      def flat_array arr
        arr.map { |a| "'" + a.to_s.gsub("'","\\\\'") + "'" }.join(",")
      end
      
    end
  end
end
