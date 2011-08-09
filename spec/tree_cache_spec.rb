require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::TreeCache do

  before :each do
    @c = ConfigLogic::TreeCache.new(CONFIG_DIR)
  end

  it 'should initialize correctly' do
    @c.instance_variable_get('@cache').should be_a_kind_of(Hash)
    @c.instance_variable_get('@flat_cache').should be_a_kind_of(Array)
  end

  it 'should build a valid tree cache' do
    @c.to_hash.should ==
      {"dir1"=>{"config1"=>{"key1"=>"data"}, 
       "config2"=>{"key1"=>"data"}, 
       "config3"=>{"key1"=>"data"}}, 
       "config1"=>{"key1"=>{"nestedkey1"=>1, "nestedkey2"=>2, "nestedkey3"=>3}}, 
       "config2"=>{"key1"=>{"nestedkey1"=>1, "nestedkey2"=>2, "nestedkey3"=>3}}}
  end

  it 'should rebuild cache during a reload!' do
    config_dir = "#{CONFIG_DIR}/dir1"
    @c.instance_variable_set('@load_paths', [config_dir])
    puts "BALH"
    puts @c.instance_variable_get('@load_paths')
    @c.reload!
    @c.to_hash.should ==
      {"config1"=>{"key1"=>"data"}, 
       "config2"=>{"key1"=>"data"}, 
       "config3"=>{"key1"=>"data"}}
  end

  it 'should apply global logic elements' do
  end

  it 'should return node at any path' do
    @c[:dir1, :config1, :key1].should == "data"
  end

end
