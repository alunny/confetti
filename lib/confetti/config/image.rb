module Confetti
  class Config
    class Image 
      attr_accessor :src, :width, :height, :extras

      def initialize *args
        @src = args.shift
        @height = args.shift
        @width = args.shift
        @extras = {} 
        extras = args.shift
        if !extras.nil?
          extras.keys.each do |method_name|
            if !self.class.instance_methods.include? method_name
              @extras[method_name] = extras[method_name] 

              self.metaclass.send :define_method, method_name do
                return @extras[method_name]
              end
            end
          end
        end
      end

      def metaclass
        class << self; self; end
      end
    end
  end
end

