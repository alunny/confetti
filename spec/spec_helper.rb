require "confetti"

module HelpfulPaths
  @spec_dir         = File.dirname(__FILE__)
  @fixture_dir      = @spec_dir + "/fixtures"
  @templates_dir    = File.expand_path "../lib/confetti/templates", @spec_dir
end
