class ConfigLogic::TreeCache < ConfigLogic::Cache

  def initialize(load_paths, params = {})
    @global_logic = params.inject([]) do |a, (type_name, elements)|
      type_name = type_name.to_s.singularize
      type = ConfigLogic::LogicElement.name_to_type(type_name)
      type ? a << elements.map { |settings| type.new(settings) } : a
    end.flatten
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
    unless @cache.empty?
      trim_cache! unless params[:no_trim]
      @flat_cache = flatten_tree_cache
      apply_global_logic
    end
    super
  end

  def insert_logic_element(element, node)
    input_names = element.input_names
    input_names.each do |input_name|
      element.set_input(input_name, node[input_name])
    end
    log.debug "inserted logic element:\n#{element.pretty_inspect}"

    node[element.name] = element.static? ? element.output : element
    prune!(node, input_names)
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

  def nodes_with_keys(keys, min_matches = 1)
    self.select do |node|
      node_keys = node.keys
      node_keys.size - (node_keys - keys).size >= min_matches
    end
  end

  def prune!(node, keys)
    node.reject! { |k, v| keys.include?(k) }
  end

# logic helpers

  def apply_global_logic
    @global_logic.each do |element|
      log.debug "applying #{element.class}: #{[element.name, element.input_names].inspect}"
      insert_global_logic_element(element)
    end
  end

  def insert_global_logic_element(element)
    matching_nodes = nodes_with_keys(element.input_names, element.min_inputs)
    log.debug "matching nodes:\n#{matching_nodes.pretty_inspect}"
    matching_nodes.each do |node|
      insert_logic_element(element, node)
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
