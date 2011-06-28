module Confetti
  class Config
    include Helpers
    include PhoneGap
    self.extend TemplateHelper

    attr_accessor :package, :version_string, :version_code, :description,
                  :height, :width
    attr_reader :author, :viewmodes, :name, :license, :content,
                :icon_set, :feature_set, :preference_set, :xml_doc,
                :splash_set

    generate_and_write  :android_manifest, :android_strings, :webos_appinfo,
                        :ios_info, :symbian_wrt_info, :blackberry_widgets_config

    # classes that represent child elements
    Author      = Class.new Struct.new(:name, :href, :email)
    Name        = Class.new Struct.new(:name, :shortname)
    License     = Class.new Struct.new(:text, :href)
    Content     = Class.new Struct.new(:src, :type, :encoding)
    Image       = Class.new Struct.new(:src, :height, :width, :extras)
    Feature     = Class.new Struct.new(:name, :required)
    Preference  = Class.new Struct.new(:name, :value, :readonly)

    def initialize(*args)
      @author           = Author.new
      @name             = Name.new
      @license          = License.new
      @content          = Content.new
      @icon_set         = TypedSet.new Image
      @feature_set      = TypedSet.new Feature
      @splash_set       = TypedSet.new Image
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

      # save reference to xml doc
      @xml_doc = config_doc

      @package = config_doc.attributes["id"]
      @version_string = config_doc.attributes["version"]
      @version_code = config_doc.attributes["versionCode"]

      config_doc.elements.each do |ele|
        attr = ele.attributes

        case ele.name
        when "name"
          @name = Name.new(ele.text.nil? ? "" : ele.text.strip, attr["shortname"])
        when "author"
          @author = Author.new(ele.text.nil? ? "" : ele.text.strip, attr["href"], attr["email"])
        when "description"
          @description = ele.text.nil? ? "" : ele.text.strip
        when "icon"
          extras = grab_extras attr
          @icon_set << Image.new(attr["src"], attr["height"], attr["width"], extras)
        when "splash"
          extras = grab_extras attr
          @splash_set << Image.new(attr["src"], attr["height"], attr["width"], extras)
        when "feature"
          @feature_set  << Feature.new(attr["name"], attr["required"])
        when "preference"
          @preference_set << Preference.new(attr["name"], attr["value"], attr["readonly"])
        when "license"
          @license = License.new(ele.text.nil? ? "" : ele.text.strip, attr["href"])
        end
      end
    end

    def icon
      @icon_set.first
    end

    def biggest_icon
      @icon_set.max { |a,b| a.width.to_i <=> b.width.to_i }
    end

    def splash
      @splash_set.first
    end

    # simple helper for grabbing chosen orientation, or the default
    # returns one of :portrait, :landscape, or :default
    def orientation
      values = %w{portrait landscape default}
      pref = @preference_set.detect { |pref| pref.name == "orientation" }

      unless pref && pref.value
        :default
      else
        values.include?(pref.value) ? pref.value.to_sym : :default
      end
    end

    def grab_extras(attributes)
      extras = attributes.keys.inject({}) do |hash, key|
        hash[key] = attributes[key] unless Image.public_instance_methods.include? key
        hash
      end
      extras
    end
  end
end
