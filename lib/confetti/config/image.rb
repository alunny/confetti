module Confetti
  class Config
    class Image 
      attr_accessor :src, :width, :height, :extras,
        :role, :platform, :main, :density, :state

      def initialize *args
        @src = args.shift
        @height = args.shift
        @width = args.shift

        @extras   = (args.shift || {}).reject do |name, val|
          %w{src height width}.include?(name)
        end

        @role     = @extras['role']
        @platform = @extras['platform']
        @main     = @extras['main']
        @density     = @extras['density']
        @state     = @extras['state']
      end
    end
  end
end

