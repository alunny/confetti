require "confetti"

module HelpfulPaths
  SPEC_DIR         = File.dirname(__FILE__)
  FIXTURE_DIR      = SPEC_DIR + "/fixtures"
  TEMPLATES_DIR    = File.expand_path "../lib/confetti/templates", SPEC_DIR

  def fixture_dir
    FIXTURE_DIR
  end

  def templates_dir
    TEMPLATES_DIR
  end
end
