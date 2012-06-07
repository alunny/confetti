module Confetti
  class Config
    class XMLError < Confetti::Error ; end
    class FileError < Confetti::Error ; end
    class FiletypeError < Confetti::Error ; end

    # classes that represent child elements
    Author      = Class.new Struct.new(:name, :href, :email)
    Name        = Class.new Struct.new(:name, :shortname)
    License     = Class.new Struct.new(:text, :href)
    Content     = Class.new Struct.new(:src, :type, :encoding)
    Feature     = Class.new Struct.new(:name, :required)
    Preference  = Class.new Struct.new(:name, :value, :readonly)
    Access      = Class.new Struct.new(:origin, :subdomains, :browserOnly)
    Param       = Class.new Struct.new(:name, :value)
  end
end
