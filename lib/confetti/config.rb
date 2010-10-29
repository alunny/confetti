module Confetti
  class Config
    attr_accessor :name, :package, :version, :description
    attr_reader :author

    def initialize
      @author = Author.new
    end

    class Author
      attr_accessor :name, :href, :email
    end
  end
end
