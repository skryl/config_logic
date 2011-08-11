class ConfigLogic::Multiplexer < ConfigLogic::LogicElement

  attr_reader :selector

  def initialize(params)
    super
    @multiplexer = params[:inputs]
    @inputs = HashWithIndifferentAccess.new(@multiplexer.values.to_hash)
    @selector = params[:selector]
  end

  def output
    return unless inputs_valid?
    case @selector
    when Proc
      @inputs[@multiplexer[@selector.call]]
    else
      @inputs[@multiplexer[@selector]]
    end
  end

end
