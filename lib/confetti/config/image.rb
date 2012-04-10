module Confetti
  class Config
    class Image 
      attr_accessor :src, :width, :height, :extras, :role, :platform, :main

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
      end
    end
  end
end

