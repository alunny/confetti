module Confetti
  class Config
    class Feature
      attr_reader :param_set

      Param = Class.new

      def initialize
        @param_set = TypedSet.new Param
      end
    end
  end
end
