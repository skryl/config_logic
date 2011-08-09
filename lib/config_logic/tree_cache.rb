class ConfigLogic::TreeCache < ConfigLogic::Cache

  def initialize(load_paths, params = {})
    @global_logic = { ConfigLogic::Multiplexer => params[:multiplexers], 
                      ConfigLogic::Overlay => params[:overlays] }
    super
  end

  def [](*key_path)
    return @cache if key_path.blank?
    key_path.inject(@cache) do |val, key|
      val[key] if val
    end
  end

  def reload!(params = {})
    @cache = rebuild_primary_cache(params)
    trim_cache! unless params[:no_trim]
    @flat_cache = flatten_tree_cache
    apply_global_logic!
    super
  end

private

  def rebuild_primary_cache(params)
    file_cache = ConfigLogic::FileCache.new(@load_paths)
    return {} unless valid_file_cache?(file_cache)

    tree_cache = HashWithIndifferentAccess.new
    file_cache.each do |path, content|
      tree_cache = tree_cache.weave(hashify_path(path, content))
    end
    tree_cache
  end

  def hashify_path(path, content)
    path_keys = split_file_path(path)
    content = HashWithIndifferentAccess.new({ path_keys.pop => content })
    path_keys.reverse.inject(content) do |content, key| 
      HashWithIndifferentAccess.new({ key => content })
    end
  end

  def trim_cache!
    return if @cache.size > 1

    until @cache.size > 1 do
      @cache = @cache[@cache.keys.first]
    end
  end

# node cache helpers

  def flatten_tree_cache
    flatten = Proc.new do |tree_cache|
      tree_cache.inject([]) do |hashes, (k,v)|
        if v.is_a? Hash
          hashes << v << flatten.call(v)
        else hashes end
      end.flatten
    end
    flatten.call(@cache) << @cache
  end

  def nodes_at(keys, min_matches = 1)
    self.select do |node|
      node_keys = node.keys
      node_keys.size - (node_keys - keys).size >= min_matches
    end
  end

  def prune!(node, keys)
    node.reject! { |k, v| keys.include?(k) }
  end

# logic helpers

  def apply_global_logic!
    @global_logic.each do |klass, elements|
      next if elements.blank?
      elements.each do |settings|
        log.debug "applying #{klass}: #{settings.inspect}"
        insert_logic_element(klass, settings)
      end
    end
  end

  def insert_logic_element(klass, settings)
    input_keys, static = settings.values_at(:inputs, :static)
    input_keys.stringify_symbols!
    matching_nodes = nodes_at(input_keys, klass.min_inputs)
    matching_nodes.each do |node|
      # all cache branches that match the keys param are used as inputs to the
      # logic element
      inputs = node.values_at(*input_keys) 
      element = klass.new(settings.merge(:input_names => settings[:inputs], :inputs=> inputs))
      node[element.name] = static ? element.output : element

      # finally the cache tree branches used as inputs are pruned
      prune!(node, input_keys)
    end
  end

# path helpers

  def split_file_path(path)
    basename = File.basename(path, '.*')
    dirname = File.dirname(path)
    dirname.split('/')[1..-1] << basename
  end

  def valid_file_cache?(file_cache)
    if file_cache.empty?
      log.error "file cache is empty"; false
    else true end
  end

# enumerable

  def each
    @flat_cache.each do |node|
      yield node
    end
  end

end
