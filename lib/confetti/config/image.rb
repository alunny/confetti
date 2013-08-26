module Confetti
  class Config
    class Image 
      attr_accessor :src, :width, :height, :extras,
        :role, :platform, :main, :density, :state, :keeporiginal

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
        @density  = @extras['density']
        @state    = @extras['state']
        @keeporiginal = @extras['keeporiginal']
      end

      def defined_attrs
        {
            "src" => @src,
            "height" => @height,
            "width" => @width,
            "gap:role" => @role,
            "gap:platform" => @platform,
            "gap:main" => @main,
            "gap:density" => @density,
            "gap:state" => @state,
            "gap:keeporiginal" => @keeporiginal
        }
      end
    end
  end
end

