module Confetti
  class Config
    attr_accessor :package, :version, :description, :height, :width
    attr_reader :author, :viewmodes, :name, :license

    def initialize
      @author = Author.new
      @name = Name.new
      @license = License.new
      @viewmodes = []
    end

    class Author
      attr_accessor :name, :href, :email
    end

    class Name
      attr_accessor :name, :shortname
    end

    class License
    end
  end
end
