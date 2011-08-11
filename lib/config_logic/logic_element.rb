require 'set'

class ConfigLogic::LogicElement
  include ConfigLogic::Logger

  MIN_INPUTS = 2
  NAME = 'logic_element'
  STATIC = true

  attr_reader :name, :inputs
  cattr_reader :min_inputs, :types
  @@types = Set.new
  @@min_inputs = MIN_INPUTS

  def initialize(params)
    @name = params[:name] || NAME
    @static = params[:static].nil? ? STATIC : params[:static]
    @inputs = HashWithIndifferentAccess.new
  end

  def set_input(input_name, value)
    @inputs[input_name] = value
  end

  def input_names
    @inputs.keys
  end

  def static?
    @static
  end

class << self

  def inherited(child)
    @@types << child
  end

  def available_elements
    @@types.map { |t| t.simple_name.downcase }
  end

  def name_to_type(name)
    if available_elements.include?(name)
      ('ConfigLogic::' + name.classify).constantize
    end
  end

end

private

  def inputs_valid?
    input_count = @inputs.values.compact.size
    if input_count < min_inputs 
      log.error("number of inputs (#{input_count}) is less than minimum (#{@@min_inputs})") 
      false
    else true
    end
  end

end
