module Confetti
  class Config
    attr_accessor :name, :package, :version, :description
    attr_reader :author

    def initialize
      @author = Author.new
    end

    class Author
    end
  end
end
