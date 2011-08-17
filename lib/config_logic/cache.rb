class ConfigLogic::Cache < SimpleDelegator
  include ConfigLogic::Logger
  include Enumerable

  def initialize(load_paths, params = {})
    @load_paths = [load_paths].flatten
    reload!(params)
    super(@cache)
  end

  def reload!(params = {})
    __setobj__(@cache)
    self
  end

  def each
    @cache.each do |node|
      yield node
    end
  end

end
