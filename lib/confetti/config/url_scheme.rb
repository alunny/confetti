module Confetti
  class Config
    class UrlScheme 
      attr_accessor :name, :role, :schemes

      def initialize *args
        scheme_arg = args.shift
        @schemes = scheme_arg.nil? ? [] : scheme_arg
        @name = args.shift
        @role = args.shift
      end
    
    end
  end
end

