class ConfigLogic

  def initialize(load_paths, params = {})
    @cache = TreeCache.new([load_paths].flatten, params)
    @path = params[:path] || []
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

  def reload!
    @cache.reload!
  end

  def to_hash
    @cache[*@path]
  end

  def inspect
    self.to_hash.inspect
  end

protected

  def clone_with_new_path(path)
    clone = self.dup
    clone.instance_variable_set('@cache', @cache)
    clone.instance_variable_set('@path', path)
    clone
  end

private
  
  def method_missing(method_symbol, *args)
    data = self[method_symbol]
    if data 
      data 
    elsif self.to_hash.respond_to?(method_symbol)
      self.to_hash.send(method_symbol)
    else super
    end
  end

end
