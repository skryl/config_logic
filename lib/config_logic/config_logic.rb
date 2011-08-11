class ConfigLogic < SimpleDelegator
  extend Forwardable

  def_delegators :@cache, :reload!
  def_delegators :@data, :inspect

  def initialize(load_paths, params = {})
    @cache = TreeCache.new([load_paths].flatten, params)
    @path = params[:path] || []
    @data = @cache[*@path]
    super(@data)
  end

  def [](*keys)
    new_path = @path + keys
    val = @cache[*new_path] 

    case val
    when Hash
      self.clone_with_new_path(new_path)
    when ConfigLogic::LogicElement
      val.output
    else val
    end
  end

protected

  def clone_with_new_path(path)
    clone = self.dup
    clone.instance_variable_set('@path', path)
    new_delegate = \
      clone.instance_variable_set('@data', @cache[*path])
    clone.__setobj__(new_delegate)
    clone
  end

private
  
  def method_missing(method_symbol, *args)
    method_name = method_symbol.to_s
    element_matcher = ConfigLogic::LogicElement.available_elements.join('|')

    if (val = self[method_symbol])
      val
    elsif /^insert_(#{element_matcher})$/ === method_name
      type = ConfigLogic::LogicElement.name_to_type($1)
      @cache.insert_logic_element(type.new(args.first), @data) if type
    else
      super
    end
  end

end
