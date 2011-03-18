module Confetti
  class Config
    class Feature
      attr_reader :param_set

      Param = Class.new

      def initialize(name, src)
        @param_set = TypedSet.new Param
        super name, src
      end
    end
  end
end
