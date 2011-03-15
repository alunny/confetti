module Confetti
  class Config
    include Helpers
    self.extend TemplateHelper

    attr_accessor :package, :version, :description, :height, :width
    attr_reader :author, :viewmodes, :name, :license, :content, 
                :icon_set, :feature_set, :preference_set

    generate_and_write  :android_manifest, :android_strings, :webos_appinfo,
                        :ios_info, :symbian_wrt_info, :blackberry_widgets_config

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
      begin
        config_doc = REXML::Document.new(File.read(xml_file)).root
      rescue REXML::ParseException
        raise ArgumentError, "malformed config.xml"
      end

      fail "no doc parsed" unless config_doc

      @package = config_doc.attributes["id"]
      @version = config_doc.attributes["version"]

      config_doc.elements.each do |ele|
        case ele.name
        when "name"
          @name = Name.new(ele.text.strip, ele.attributes["shortname"])
        when "author"
          @author = Author.new(ele.text.strip, ele.attributes["href"], 
                               ele.attributes["email"])
        when "description"
          @description = ele.text.strip
        when "icon"
          @icon_set << Icon.new(ele.attributes["src"], ele.attributes["height"],
                                ele.attributes["width"])
        end
      end
    end

    def icon
      @icon_set.first
    end

    def biggest_icon
      @icon_set.max { |a,b| a.width.to_i <=> b.width.to_i }
    end
  end
end
