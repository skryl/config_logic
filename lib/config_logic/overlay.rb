class ConfigLogic::Overlay < ConfigLogic::LogicElement
  
  attr_reader :order

  def initialize(params)
    super
    @order = params[:inputs]
    @inputs = HashWithIndifferentAccess.new(@order.to_hash)
  end

  # merge if possible, return highest priority data if not
  #
  def output
    return unless inputs_valid?
    if @inputs.values.all? { |d| d.is_a? Hash }
      @order.inject({}) do |output, input_name|
        output.merge!(@inputs[input_name])
      end
    else
      @inputs[@order.last]
    end
  end

end
