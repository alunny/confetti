module Confetti
  class Config
    attr_accessor :package, :version, :description, :height, :width
    attr_reader :author, :viewmodes

    def initialize
      @author = Author.new
      @viewmodes = []
    end

    class Author
      attr_accessor :name, :href, :email
    end
  end
end
