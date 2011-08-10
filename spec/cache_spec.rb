require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::Cache do

  before :each do
    @c = ConfigLogic::Cache.new(CONFIG_DIR)
  end

  it 'should initialize correctly' do
    @c.should be_an_instance_of(ConfigLogic::Cache)
    @c.instance_variable_get('@load_paths').should == CONFIG_DIR
  end

  it 'should delegate unknown calls to the cache container' do
    cache = @c.instance_variable_get('@cache')
    cache.public_methods(false).each do |m|
      @c.should respond_to(m)
    end
  end

end
