class ConfigLogic::Cache
  include ConfigLogic::Logger
  include Enumerable

  def empty?
    primary_cache.empty?
  end

  def reload!(params = {})
    rebuild_primary_cache!(params)
    self
  end

  def inspect
    primary_cache.inspect
  end

  def each
    primary_cache.each do |node|
      yield node
    end
  end

  def size
    primary_cache.size
  end
  alias :count :size
end

