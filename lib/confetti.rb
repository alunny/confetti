CURRENT_DIR = File.dirname(__FILE__)

# stdlib
require "rexml/document"

# external dependencies
begin
  require "bundler/setup"
rescue LoadError
  require "rubygems"
  require "bundler/setup"
end

require "mustache"

# internal dependencies
require 'typedset'
require 'confetti/version'
require 'confetti/error'
require 'confetti/helpers'
require 'confetti/phonegap'

require 'confetti/template'
require 'confetti/templates/base'
require 'confetti/templates/java_checks'
require 'confetti/templates/version_helper'

require 'confetti/templates/android_manifest'
require 'confetti/templates/android_strings'
require 'confetti/templates/blackberry_widgets_config'
require 'confetti/templates/ios_info'
require 'confetti/templates/ios_remote_plist'
require 'confetti/templates/symbian_wrt_info'
require 'confetti/templates/webos_appinfo'
require 'confetti/templates/windows_phone7_manifest'

require 'confetti/template_helper'

require 'confetti/config'
require 'confetti/config/feature'

require 'digest/md5'
