require 'buffered_logger'

class ConfigLogic::Log
  private_class_method :new
  LOG_LEVEL = 0

  def self.init_log(log_level, color)
    @log = BufferedLogger.new(STDOUT, log_level || LOG_LEVEL, default_format)
    log.disable_color unless color
  end

  def self.log
    @log ||=  BufferedLogger.new(STDOUT, LOG_LEVEL, default_format) 
  end

private
  
  def self.default_format
    { :debug => "$negative DEBUG: $reset %s",
      :warn  => "$yellow WARNING: $reset %s",
      :error => "$red ERROR: $reset %s" }
  end

end


module ConfigLogic::Logger
  module Colors
    RED   = '$red'
    BLUE  = '$blue'
    GREEN = '$green'
    YELLOW = '$yellow'
    RESET = '$reset'
  end
  include Colors

  def log
    ConfigLogic::Log.log
  end
end
