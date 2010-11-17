module Confetti
  class Config
    include Helpers

    attr_accessor :package, :version, :description, :height, :width
    attr_reader :author, :viewmodes, :name, :license, :content, 
                :icon_set, :feature_set, :preference_set

    # classes that represent child elements
    Author      = Class.new Struct.new(:name, :href, :email)
    Name        = Class.new Struct.new(:name, :shortname)
    License     = Class.new Struct.new(:text, :href)
    Content     = Class.new Struct.new(:src, :type, :encoding)
    Icon        = Class.new Struct.new(:src, :height, :width)
    Feature     = Class.new Struct.new(:name, :required)
    Preference  = Class.new Struct.new(:name, :value, :readonly)

    def initialize(*args)
      @author           = Author.new
      @name             = Name.new
      @license          = License.new
      @content          = Content.new
      @icon_set         = TypedSet.new Icon
      @feature_set      = TypedSet.new Feature
      @preference_set   = TypedSet.new Preference
      @viewmodes        = []
    end

    def write_for_android(destination)
    end
  end
end
