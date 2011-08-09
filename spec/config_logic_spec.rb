require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic do

  before :each do
    @c = ConfigLogic.new(CONFIG_DIR)
  end

  it 'should initialize correctly' do
    @c.should be_an_instance_of(ConfigLogic)
    @c.instance_variable_get('@cache').should be_an_instance_of(ConfigLogic::TreeCache)
    @c.instance_variable_get('@path').should be_an_instance_of(Array)
  end

  it 'should delegate unknown calls to cache node' do
    cache = @c.instance_variable_get('@cache')
    cache.public_methods(false).each do |m|
      @c.should respond_to(m)
    end
  end

  it 'should delegate reload! and inspect calls' do
    @c.should respond_to(:reload!)
    @c.should respond_to(:inspect)
  end

  it 'should return cache values based on hash style arguments' do
  end

  it 'should return cache values via method missing' do
  end

end
