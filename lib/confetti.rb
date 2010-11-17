# stdlib
require "rexml/document"

# external dependencies
begin
  require "bundler/setup"
rescue LoadError
  require "rubygems"
  require "bundler/setup"
end

Bundler.require :default

# internal dependencies
require 'typedset'
require 'confetti/version'
require 'confetti/helpers'

require 'confetti/template'
require 'confetti/templates/base'
require 'confetti/templates/android'

require 'confetti/config'
require 'confetti/config/feature'
