module Confetti
  class Config
    class XMLError < Confetti::Error ; end
    class FileError < Confetti::Error ; end
    class FiletypeError < Confetti::Error ; end
    class EncodingError < Confetti::Error ; end

    # classes that represent child elements
    class Author < Struct.new(:name, :href, :email)
      def defined_attrs
        {
          "name"  => self[ :name ],
          "href"  => self[ :href ],
          "email" => self[ :email ]
        }
      end
    end

    class Name < Struct.new(:name, :shortname)
      def defined_attrs
        {
          "name" => self[ :name ],
          "shortname" => self[ :shortname ]
        }
      end
    end

    class License < Struct.new(:text, :href)
      def defined_attrs
        {
          "text" => self[ :text ],
          "href" => self[ :href ]
        }
      end
    end

    class Content < Struct.new(:src, :type, :encoding)
      def defined_attrs
        {
          "src" => self[ :src ],
          "type" => self[ :type ],
          "encoding" => self[ :encoding ]
        }
      end
    end

    class Feature < Struct.new(:name, :required)
      def defined_attrs
        {
          "name" => self[ :name ],
          "required" => self[ :required ]
        }
      end
    end

    class Preference < Struct.new(:name, :value, :readonly)
      def defined_attrs
        {
          "name" => self[ :name ],
          "value" => self[ :value ],
          "readonly" => self[ :readonly ]
        }
      end
    end

    class Access < Struct.new(:origin, :subdomains, :browserOnly)
      def defined_attrs
        {
          "origin" => self[ :origin ],
          "subdomains" => self[ :subdomains ],
          "browserOnly" => self[ :browserOnly ]
        }
      end
    end

    class Param < Struct.new(:name, :value)
      def defined_attrs
        {
          "name" => self[ :name ],
          "value" => self[ :value ]
        }
      end
    end
  end
end
