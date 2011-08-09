class ConfigLogic::Multiplexer < ConfigLogic::LogicElement

  attr_reader :selector

  def initialize(params)
    super
    @inputs = params[:input_names].zip(params[:inputs]).to_hash
    @selector = params[:selector]
  end

  def output
    @inputs[@selector.call]
  end

end
