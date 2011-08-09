require 'yaml'
require 'find'

class ConfigLogic::FileCache < ConfigLogic::Cache

  PARSER_MAP = {
    ['.yaml', '.yml'] => lambda do |path| YAML::load_file(path) end, 
    ['.txt']          => lambda do |path| File.read(path) end, 
    ['.json']         => lambda do |path| end }.freeze

  VALID_EXTENSIONS = PARSER_MAP.map { |(extensions, parser_proc)| extensions }.flatten!.freeze

  def reload!(params = {})
    @cache = rebuild_primary_cache(params)
    super
  end

private

  def rebuild_primary_cache(params)
    file_cache = []
    load_file = Proc.new do |path|
    end

    valid_files = @load_paths.inject([]) do |valid, path| 
      valid << find_valid_files(path)
    end.flatten

    valid_files.each do |path|
      content = parse(path)
      file_cache << [path, content] if content
      log.debug "found file #{BLUE} #{path}"
    end 

    file_cache.inject({}) do 
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

  def parse(path)
    parser = find_parser(path)
    return unless parser

    begin
      parser.call(path)
    rescue => e
      log.warn "#{RED} #{path} #{RESET} is not a valid config file"
    end
  end

  def find_parser(path)
    parser = PARSER_MAP.detect { |(extensions, parse_proc)| extensions.include?(File.extname(path)) }
    parser ? parser.last : nil
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
