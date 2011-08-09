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
    clone.instance_variable_set('@data', @cache[*path])
    clone
  end

private
  
  def method_missing(method_symbol, *args)
    self[method_symbol] || super
  end

end
