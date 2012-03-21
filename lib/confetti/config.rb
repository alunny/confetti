module Confetti
  class Config
    include Helpers
    include PhoneGap
    self.extend TemplateHelper

    class XMLError < Confetti::Error ; end

    class FileError < Confetti::Error ; end

    class FiletypeError < Confetti::Error ; end

    attr_accessor :package, :version_string, :version_code, :description,
                  :height, :width, :plist_icon_set
    attr_reader :author, :viewmodes, :name, :license, :content,
                :icon_set, :feature_set, :preference_set, :xml_doc,
                :splash_set, :plist_icon_set, :access_set

    generate_and_write  :android_manifest, :android_strings, :webos_appinfo,
                        :ios_info, :symbian_wrt_info, :blackberry_widgets_config,
                        :ios_remote_plist, :windows_phone7_manifest

    # handle bad generate/write calls
    def method_missing(method_name, *args)
      bad_call = /^(generate)|(write)_(.*)$/
      matches = method_name.to_s.match(bad_call)

      if matches
        raise FiletypeError, "#{ matches[3] } not supported"
      else
        super method_name, *args
      end
    end

    # classes that represent child elements
    Author      = Class.new Struct.new(:name, :href, :email)
    Name        = Class.new Struct.new(:name, :shortname)
    License     = Class.new Struct.new(:text, :href)
    Content     = Class.new Struct.new(:src, :type, :encoding)
    Image       = Class.new Struct.new(:src, :height, :width, :extras)
    Feature     = Class.new Struct.new(:name, :required)
    Preference  = Class.new Struct.new(:name, :value, :readonly)
    Access      = Class.new Struct.new(:origin, :subdomains)

    def initialize(*args)
      @author           = Author.new
      @name             = Name.new
      @license          = License.new
      @content          = Content.new
      @icon_set         = TypedSet.new Image
      @plist_icon_set   = [] 
      @feature_set      = TypedSet.new Feature
      @splash_set       = TypedSet.new Image
      @preference_set   = TypedSet.new Preference
      @access_set       = TypedSet.new Access
      @viewmodes        = []

      if args.length > 0 && is_file?(args.first)
        populate_from_xml args.first
      end
    end

    def populate_from_xml(xml_file)
      begin
        file = File.read(xml_file)
        config_doc = REXML::Document.new(file).root
      rescue REXML::ParseException
        raise XMLError, "malformed config.xml"
      rescue Errno::ENOENT
        raise FileError, "file #{ xml_file } doesn't exist"
      end

      if config_doc.nil?
        raise XMLError, "no doc parsed"
      end

      # save reference to xml doc
      @xml_doc = config_doc

      @package = config_doc.attributes["id"]
      @version_string = config_doc.attributes["version"]
      @version_code = config_doc.attributes["versionCode"]

      config_doc.elements.each do |ele|
        attr = ele.attributes

        case ele.namespace

        # W3C widget elements
        when "http://www.w3.org/ns/widgets"
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
            # used for the info.plist file
            @plist_icon_set << attr["src"]
          when "feature"
            @feature_set  << Feature.new(attr["name"], attr["required"])
          when "preference"
            @preference_set << Preference.new(attr["name"], attr["value"], attr["readonly"])
          when "license"
            @license = License.new(ele.text.nil? ? "" : ele.text.strip, attr["href"])
          when "access"
            sub = attr["subdomains"]
            sub = sub.nil? ? true : (sub != 'false')
            @access_set << Access.new(attr["origin"], sub)
          end

        # PhoneGap extensions (gap:)
        when "http://phonegap.com/ns/1.0"
          case ele.name
          when "splash"
            next if attr["src"].nil? or attr["src"].empty?
            extras = grab_extras attr
            @splash_set << Image.new(attr["src"], attr["height"], attr["width"], extras)
          end
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
      values = [:portrait, :landscape, :default]
      choice = preference :orientation

      unless choice and values.include?(choice)
        :default
      else
        choice
      end
    end

    def grab_extras(attributes)
      extras = attributes.keys.inject({}) do |hash, key|
        hash[key] = attributes[key] unless Image.public_instance_methods.include? key
        hash
      end
      extras
    end

    # helper to retrieve a preference's value
    # returns nil if the preference doesn't exist
    def preference name
      pref = preference_obj(name)

      pref && pref.value && pref.value.to_sym
    end

    # mostly an internal method to help with weird cases
    # in particular #phonegap_version
    def preference_obj name
      name = name.to_s
      @preference_set.detect { |pref| pref.name == name }
    end

    def full_access?
      @access_set.detect { |a| a.origin == '*' }
    end
  end
end
