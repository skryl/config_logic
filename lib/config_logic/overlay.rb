class ConfigLogic::Overlay < ConfigLogic::LogicElement
  
  def initialize(params)
    super
    @inputs = params[:inputs]
  end

  # merge if possible, return highest priority data if not
  #
  def output
    if @inputs.all? { |d| d.is_a? Hash }
      @inputs.inject({}) do |output, data|
        output.merge!(data)
      end
    else
      @inputs.last
    end
  end

end
