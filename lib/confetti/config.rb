module Confetti
  class Config
    include Helpers
    include PhoneGap
    self.extend TemplateHelper

    attr_accessor :package, :version_string, :version_code, :description,
                  :height, :width, :plist_icon_set
    attr_reader :author, :viewmodes, :name, :license, :content,
                :icon_set, :feature_set, :preference_set, :xml_doc,
                :splash_set, :plist_icon_set, :access_set, :plugin_set

    generate_and_write  :android_manifest, :android_strings,
                        :webos_appinfo, :ios_info, :symbian_wrt_info,
                        :blackberry_widgets_config, :ios_remote_plist,
                        :windows_phone7_manifest

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

    def initialize( *args )
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

      # defined in PhoneGap module
      @plugin_set       = TypedSet.new Plugin
      @viewmodes        = []

      return if args.empty?

      input = args.first

      if is_file?( input ) || File.extname( input ) == ".xml"
        populate_from_xml input
      elsif input.kind_of?( String )
        populate_from_string input
      end
    end

    def populate_from_xml(xml_file)
      begin
        file = File.read(xml_file)
      rescue Errno::ENOENT
        raise FileError, "file #{ xml_file } doesn't exist"
      end
      
      populate file 
    end

    def populate_from_string( xml_str )
      populate xml_str 
    end

    def populate( config_doc )
      begin
        config_doc = REXML::Document.new( config_doc ).root
      rescue REXML::ParseException
        raise XMLError, "malformed config.xml"
      rescue Iconv::InvalidCharacter
        raise EncodingError, "unable to read config.xml"
      end

      if config_doc.nil?
        raise XMLError, "no doc parsed"
      end

      @xml_doc = config_doc # save reference to doc

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
            @name = Name.new(ele.text.nil? ? "" : ele.text.strip,
                              attr["shortname"])

          when "author"
            @author = Author.new(ele.text.nil? ? "" : ele.text.strip,
                                  attr["href"], attr["email"])

          when "description"
            @description = ele.text.nil? ? "" : ele.text.strip

          when "icon"
            @icon_set << Image.new(attr["src"], attr["height"], attr["width"],
                                    attr)
            # used for the info.plist file
            @plist_icon_set << attr["src"]

          when "feature"
            @feature_set  << Feature.new(attr["name"], attr["required"])

          when "preference"
            @preference_set << Preference.new(attr["name"], attr["value"],
                                              attr["readonly"])

          when "license"
            @license = License.new(ele.text.nil? ? "" : ele.text.strip,
                                   attr["href"])

          when "access"
            sub = boolean_value(attr["subdomains"], true)
            browserOnly = boolean_value(attr["browserOnly"])
            @access_set << Access.new(attr["origin"], sub, browserOnly)
          end

        # PhoneGap extensions (gap:)
        when "http://phonegap.com/ns/1.0"
          case ele.name
          when "splash"
            next if attr["src"].nil? or attr["src"].empty?
            @splash_set << Image.new(attr["src"], attr["height"], attr["width"],
                                      attr)

          when "plugin"
            next if attr["name"].nil? or attr["name"].empty?
            plugin = Plugin.new(attr["name"], attr["version"])
            ele.each_element('param') do |param|
              p_attr = param.attributes
              plugin.param_set << Param.new(p_attr["name"], p_attr["value"])
            end
            @plugin_set << plugin
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

    # helper to retrieve a preference's value
    # returns nil if the preference doesn't exist
    def preference name
      pref = preference_obj(name)

      if pref && pref.value && !pref.value.empty?
        pref.value.to_sym
      end
    end

    # mostly an internal method to help with weird cases
    # in particular #phonegap_version
    def preference_obj name
      name = name.to_s
      @preference_set.detect { |pref| pref.name == name }
    end

    def feature name
      @feature_set.detect { |feature| feature.name == name }
    end

    def full_access?
      @access_set.detect { |a| a.origin == '*' }
    end

    def find_best_fit_img images, opts = {}
      opts['width']     ||= nil
      opts['height']    ||= nil
      opts['role']      ||= nil
      opts['density']      ||= nil
      opts['state']      ||= nil
      opts['platform']  ||= nil

      # filters to look through sets for
      filters = [
        {'height' => opts['height'], 'width' => opts['width']},
        {'platform' => opts['platform'], 'density' => opts['density']},
        {'platform' => opts['platform'], 'state' => opts['state']},
        {'platform' => opts['platform'], 'role' => opts['role']},
        {'platform' => opts['platform']}
      ]

      matches = nil

      filters.each do |filter|
        matches = filter_images(images, filter)

        if matches.length == 1
          break
        end
      end

      matches.first unless matches.empty?
    end

    def default_icon
      @icon_set.each do |icon|
        return icon if icon.src.match /^icon(\.[a-zA-Z0-9]+)+$/i
      end
      nil
    end

    def default_splash
      @splash_set.each do |splash|
        return splash if splash.src.match /^splash(\.[a-zA-Z0-9]+)$/i
      end
      nil
    end

    def filter_images images, filter
      imgs = images.clone

      # filter can have multiple criteria
      filter.each_pair do |name, value|
        imgs = imgs.reject do |img|
          !img.respond_to?(name) || img.send(name) != value
        end
      end

      imgs
    end

    # convert string (attribute) to boolean
    def boolean_value value, default=false
      if default
        value != "false"
      else
        value == "true"
      end
    end

    def filtered_to_s( xpaths = [] )
      xpaths = [ xpaths ] unless xpaths.kind_of?(Array)

      xml = @xml_doc.dup unless @xml_doc.nil?
      xml ||= to_xml

      xpaths.each do |path|
        xml.root.elements.delete_all path
      end

      xml.root.to_s
    end

    def to_s
      @xml_doc.root.to_s
    end

    def to_xml
      doc = REXML::Document.new

      widget = REXML::Element.new( "widget" )
      widget.add_attributes({
        "xmlns" => "http://www.w3.org/ns/widgets",
        "xmlns:gap" =>  "http://phonegap.com/ns/1.0",
        "id" => @package,
        "version" => @version_string
        })

      if !@version_code.nil?
        widget.add_attribute({ "versionCode" => @version_code })
      end

      name = REXML::Element.new( "name" )
      name.text = @name.name
      name.add_attribute({ "shortname" => @name.shortname })

      author = REXML::Element.new( "author" )
      author.text = @author.name
      author.add_attributes({
          "href" => @author.href,
          "email" => @author.email
          })

      description = REXML::Element.new( "description" )
      description.text = @description

      license = REXML::Element.new( "license" )
      license.text = @license.text
      license.add_attribute({ "href" => @license.href })

      icons = []
      @icon_set.each do | icon |
        ico = REXML::Element.new( "icon" )
        attrs = icon.defined_attrs
        ico.add_attributes attrs
        icons << ico
      end

      splashes = []
      @splash_set.each do | splash |
        spl = REXML::Element.new( "gap:splash" )
        attrs = splash.defined_attrs
        spl.add_attributes attrs
        splashes << spl
      end

      preferences = []
      @preference_set.each do | preference |
        pref = REXML::Element.new( "preference" )
        pref.add_attributes({
            "name" => preference.name,
            "value" => preference.value,
            "readonly" => preference.readonly
            })
        preferences << pref
      end

      features = []
      @feature_set.each do | feature |
        feat = REXML::Element.new( "feature" )
        feat.add_attributes({
            "name" => feature.name,
            "required" => feature.required,
            })
        features << feat 
      end

      widget.elements.add name 
      widget.elements.add author
      widget.elements.add description 
      widget.elements.add license 

      icons.each { | icon | widget.elements.add icon }
      splashes.each { | splash | widget.elements.add splash }
      preferences.each { | pref | widget.elements.add pref }
      features.each { | feat | widget.elements.add feat }

      doc << REXML::XMLDecl.new
      doc.elements.add widget
      doc
    end
  end
end
