require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::FileCache do

  def find_valid_files(path)
    valid_files = ConfigLogic::FileCache::VALID_EXTENSIONS.inject([]) do |valid, ext|
      valid << Dir["#{path}/**/*#{ext}"]
    end.flatten
    valid_files.reject { |f| f =~ /syntax_error/ }
  end

  def cache_valid?(path, cache)
    cache = cache.keys
    valid_files = find_valid_files(path)
    cache.empty?.should be_false
    cache.each do |cached_file|
      valid_files.include?(cached_file).should be_true
    end
  end

  before :each do
    @c = ConfigLogic::FileCache.new(CONFIG_DIR)
  end

  it 'should initialize correctly' do
    @c.instance_variable_get('@cache').should be_an_instance_of(Hash)
  end

  it 'should build a file cache of valid configs during initialization' do
    cache_valid?(CONFIG_DIR, @c.instance_variable_get('@cache')) 
  end

  it 'should rebuild cache during a reload!' do
    config_dir = "#{CONFIG_DIR}/dir1"
    @c.instance_variable_set('@load_paths', [config_dir])
    @c.reload!
    cache_valid?(config_dir, @c.instance_variable_get('@cache')) 
  end

end
