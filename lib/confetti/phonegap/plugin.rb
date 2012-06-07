module Confetti
  module PhoneGap
    class Plugin < Struct.new(:name, :version)
      attr_reader :param_set

      def initialize(name, src)
        @param_set = TypedSet.new Confetti::Config::Param
        super name, src
      end
    end
  end
end
