module Confetti
  module Helpers
    def is_file? (filename)
      File.exist? filename
    end
  end
end
