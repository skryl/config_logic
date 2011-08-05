$: << File.dirname(__FILE__)

# global
require 'rubygems'
require 'active_support/core_ext'
require 'buffered_logger'

class ConfigLogic
  module Logger; end
  include ConfigLogic::Logger
end

core_extensions = Dir['config_logic/core_ext/*.rb']
core_extensions.each { |file| require file }

require 'config_logic/logger'
require 'config_logic/cache'
require 'config_logic/file_cache'
require 'config_logic/logic_element'
require 'config_logic/multiplexer'
require 'config_logic/overlay'
require 'config_logic/tree_cache'
require 'config_logic/config_logic'
