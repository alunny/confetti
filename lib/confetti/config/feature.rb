module Confetti
  class Config
    class Feature
      attr_reader :param_set

      def initialize(name, src)
        @param_set = TypedSet.new Param
        super name, src
      end
    end
  end
end
