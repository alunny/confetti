module Confetti
  class Config
    attr_accessor :package, :version, :description, :height, :width
    attr_reader :author

    def initialize
      @author = Author.new
    end

    class Author
      attr_accessor :name, :href, :email
    end
  end
end
