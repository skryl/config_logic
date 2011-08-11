$: << File.dirname(__FILE__)

# global
require 'rubygems'
require 'active_support/core_ext/class'
require 'active_support/core_ext/string'
require 'buffered_logger'
require 'forwardable'
require 'delegate'

class ConfigLogic < SimpleDelegator
  module Logger; end
  include ConfigLogic::Logger
end

require 'config_logic/core_ext/class'
require 'config_logic/core_ext/hash'
require 'config_logic/core_ext/array'
require 'config_logic/logger'
require 'config_logic/cache'
require 'config_logic/file_cache'
require 'config_logic/logic_element'
require 'config_logic/multiplexer'
require 'config_logic/overlay'
require 'config_logic/tree_cache'
require 'config_logic/config_logic'
