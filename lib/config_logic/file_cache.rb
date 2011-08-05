require 'yaml'
require 'find'

class ConfigLogic::FileCache < ConfigLogic::Cache

  PARSER_MAP = {
    ['.yaml', '.yml'] => lambda do |path| YAML::load_file(path) end, 
    ['.txt']          => lambda do |path| File.read(path) end, 
    ['.json']         => lambda do |path| end }.freeze

  VALID_EXTENSIONS = PARSER_MAP.map { |(extensions, parser_proc)| extensions }.flatten!.freeze

  def initialize(load_paths)
    @load_paths = load_paths
    reload!
  end

protected

  def primary_cache
    @cache
  end

private

# cache helpers

  def rebuild_primary_cache!(params)
    file_cache = []
    @load_paths.each do |path|
      next unless load_path_exists?(path)

      if File.file?(path) && valid_file_ext?(path)
        file_cache << load_file(path)
        log.debug "found file #{BLUE} #{path}"
      elsif File.directory?(path)
        find_valid_files(path).each do |file|
          file_cache << load_file(file)
          log.debug "found file #{BLUE} #{file}"
        end
      end
    end 

    @cache = file_cache.compact.inject({}) do 
      |h, (path, content)| h[path] = content; h
    end
  end
  
  def find_valid_files(path)
    valid_files = []
    Find.find(path) do |file| 
      valid_files << file if valid_file_ext?(file)
    end
    valid_files
  end

# parsing helpers

  def load_file(path)
    [path, parse(path)]
  end

  def parse(path)
    parser = find_parser(path).last
    begin
      parser ? parser.call(path) : nil
    rescue => e
      log.warn "#{RED} #{path} #{RESET} is not a valid config file"
    end
  end

  def find_parser(path)
    PARSER_MAP.detect { |(extensions, parse_proc)| extensions.include?(File.extname(path)) }
  end

# path helpers

  def load_path_exists?(path)
    unless File.exists?(path)
      log.warn "#{RED} #{path} #{RESET} does not exist"; false
    else true end
  end

  def valid_file_ext?(path)
    VALID_EXTENSIONS.include?(File.extname(path))
  end

end
