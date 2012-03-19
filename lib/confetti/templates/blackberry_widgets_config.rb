module Confetti
  module Template
    class BlackberryWidgetsConfig < Base
      include VersionHelper

      @@legacy_template = File.read(
        File.join(
          File.dirname(__FILE__),
          "blackberry_widgets_config_legacy.mustache"
      ))

      ORIENTATIONS_MAP = {
        :default => "auto",
        :landscape => "landscape",
        :portrait => "portrait"
      }

      def initialize *args
        super *args

        return self unless @config

        # old = 0.x, 1.0, 1.1, or 1.2
        old = /^(0)|(1[.][0-2])/

        if @config.phonegap_version and @config.phonegap_version.match(old)
          self.template = @@legacy_template
        end
      end

      def widget_id
        if @config.package.nil? or @config.package.empty?
          "com.default.noname"
        else
          @config.package
        end
      end

      def version
        normalize_version(@config.version_string)
      end

      def widget_name
        @config.name.name
      end

      def author_href
        @config.author.href
      end

      def author_email
        @config.author.email
      end

      def author_name
        @config.author.name
      end

      def widget_description
        @config.description
      end

      def license_href
        @config.license.href
      end

      def license_text
        @config.license.text
      end

      def phonegap_version
        # should be 1.0.0, unless below 1
        # @config.phonegap_version
        pg = @config.phonegap_version

        if pg.nil? or pg.empty? or pg.match(/^1/)
          "1.0.0"
        else
          pg
        end
      end

      def output_filename
        "config.xml"
      end

      def app_orientation
        ORIENTATIONS_MAP[@config.orientation]
      end

      def no_cursor?
        @config.preference("disable-cursor") == :true
      end

      def framework_namespace
        # phonegap = 0.x, 1.0, 1.1, 1.2, 1.3, 1.4
        gap = @config.phonegap_version.match(/^(0)|(1[.][0-4])/)

        gap ? 'com.phonegap' : 'org.apache.cordova'
      end

      def access
        @config.access_set.map do |a| 
          { :subdomains => !!a.subdomains, :uri => a.origin }
        end
      end
    end
  end
end
