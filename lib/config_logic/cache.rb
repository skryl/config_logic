class ConfigLogic::Cache < SimpleDelegator
  include ConfigLogic::Logger
  include Enumerable

  def initialize(load_paths, params = {})
    @load_paths = load_paths
    reload!(params)
    super(@cache)
  end

  def reload!(params = {})
    __setobj__(@cache)
    self
  end

private

  def rebuild_primary_cache(params)
    {}
  end

  def each
    @cache.each do |node|
      yield node
    end
  end

end
