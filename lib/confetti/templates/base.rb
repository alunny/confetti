module Confetti
  module Template
    class Base < Mustache
      self.template_path = File.dirname(__FILE__)
    end
  end
end
