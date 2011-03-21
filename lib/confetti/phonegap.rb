module Confetti
  module PhoneGap
    PHONEGAP_APIS = %w{camera notification geolocation media contacts file network}

    def add_stock_phonegap_apis
      PHONEGAP_APIS.each do |api|
        api_name = "http://api.phonegap.com/1.0/#{ api }"
        self.feature_set << Confetti::Config::Feature.new(api_name, nil)
      end
    end
  end
end
