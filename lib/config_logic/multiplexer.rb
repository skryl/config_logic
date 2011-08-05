class ConfigLogic::Multiplexer < ConfigLogic::LogicElement

  def initialize(params)
    super
    @inputs = params[:input_names].zip(params[:inputs]).to_hash
    @selector = Proc.new { params[:selector] }
  end

  def output
    @inputs[@selector.call]
  end

end
