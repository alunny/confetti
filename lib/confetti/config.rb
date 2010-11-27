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

      if args.length > 0 && is_file?(args.first)
        populate_from_xml args.first
      end
    end

    def populate_from_xml(xml_file)
      config_doc = REXML::Document.new(File.read(xml_file)).root
      fail "no doc parsed" unless config_doc

      @package = config_doc.attributes["id"]

      config_doc.elements.each do |ele|
        case ele.name
        when "name"
          @name = Name.new(ele.text.strip, ele.attributes["shortname"])
        end
      end
    end

    # generate and write methods, per template
    [:android_manifest, :android_strings].each do |config_type|
      class_name = config_type.to_s.split("_").collect do |s|
        s.capitalize
      end.join
      template_class = Confetti::Template.const_get(class_name)

      generate_method = "generate_#{ config_type }".to_sym
      write_method    = "write_#{ config_type }".to_sym

      send :define_method, generate_method do
        template_class.new(self)
      end

      send :define_method, write_method do |*args|
        filepath = args.first

        template = send generate_method
        filepath ||= File.join(Dir.pwd, template.output_filename)

        open(filepath, 'w') { |f| f.puts template.render }
      end
    end
  end
end
