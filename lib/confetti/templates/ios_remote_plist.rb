module Confetti
  module Template
    class IosRemotePlist < IosInfo
      # just take the methods from IosInfo

      def output_filename
        "remote.plist"
      end
    end
  end
end
