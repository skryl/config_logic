class ConfigLogic::LogicElement
  include ConfigLogic::Logger

  MIN_INPUTS = 2
  attr_reader :name, :inputs

  def initialize(params)
    @name = params[:name]
  end

  def self.min_inputs
    MIN_INPUTS
  end

end
