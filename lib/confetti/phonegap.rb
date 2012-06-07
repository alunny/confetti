module Confetti
  module PhoneGap
    PHONEGAP_APIS = %w{camera notification geolocation media contacts file network}

    def add_stock_phonegap_apis
      PHONEGAP_APIS.each do |api|
        api_name = "http://api.phonegap.com/1.0/#{ api }"
        self.feature_set << Confetti::Config::Feature.new(api_name, nil)
      end
    end

    def phonegap_version
      self.preference("phonegap-version").to_s
    end

    def phonegap_version= v
      pref = self.preference_obj("phonegap-version")

      if pref.nil?
        pref = Confetti::Config::Preference.new("phonegap-version", v)
        self.preference_set << pref
      else
        pref.value = v
      end
    end

    # deprecated in favor of gap:plugin tags
    # still supported for ChildBrowser
    def legacy_plugins
      p_name = /http:\/\/plugins[.]phonegap[.]com\/([^\/]*)\/([^\/]*)/

      # find features corresponding to plugins
      plugin_features = self.feature_set.select do |f|
        !f.name.nil? && f.name.match(p_name)
      end

      # turn matching features into plugins
      plugin_features.map do |f|
        matches = f.name.match(p_name)
        Plugin.new(matches[1], matches[2])
      end
    end
  end
end
