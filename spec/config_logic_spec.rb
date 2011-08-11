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

  it 'should delegate unknown calls to cache node pointed to by current path' do
    node = @c.instance_variable_get('@data')
    node.public_methods(false).each do |m|
      @c.should respond_to(m)
    end
  end

  it 'should delegate reload! and inspect calls to cache' do
    @c.should respond_to(:reload!)
    @c.should respond_to(:inspect)
  end

  it 'should return cache values using multiple access methods' do
    @c[:dir1, :config1, :key1, :nestedkey1].should == 1
    @c[:dir1][:config1][:key1][:nestedkey1].should == 1
    @c['dir1', 'config1', 'key1', 'nestedkey1'].should == 1
    @c['dir1']['config1']['key1']['nestedkey1'].should == 1
    @c.dir1.config1.key1.nestedkey1.should == 1
  end

  it 'should return ConfigLogic hashes for any path that doesnt point to a simple value' do
    @c.dir1.should be_a_kind_of(ConfigLogic)
    @c.dir1.config1.should be_a_kind_of(ConfigLogic)
    @c.dir1.config1.key1.should be_a_kind_of(ConfigLogic)
  end

  it 'should apply local overlay element' do
    @c.dir1.config1.insert_overlay({:name => :over, :inputs => [:key1, :key2, :key3]})
    overlayed_result = {"nestedkey1" => 1, "nestedkey2" => 2, "nestedkey3" => 3, 
                        "nestedkey4" => 4, "nestedkey5" => 5, "nestedkey6" => 6, 
                        "nestedkey7" => 7, "nestedkey8" => 8, "nestedkey9" => 9}
    @c[:dir1][:config1][:over].to_hash.should == overlayed_result
    @c[:dir1][:config1].keys.size.should == 1
    @c[:dir1][:config2].keys.size.should == 3
  end

  it 'should apply local multiplexer element' do
    @c.dir1.insert_multiplexer({:name => :multi, :selector => 1, :inputs => {1 => :config1, 2 => :config2, 3 => :config3}})
    multiplexed_result = {"key1"=>{"nestedkey1"=>1, "nestedkey2"=>2, "nestedkey3"=>3},
                          "key2"=>{"nestedkey4"=>4, "nestedkey5"=>5, "nestedkey6"=>6},
                          "key3"=>{"nestedkey7"=>7, "nestedkey8"=>8, "nestedkey9"=>9}} 
    @c[:dir1][:multi].to_hash.should == multiplexed_result
    @c[:dir1].keys.size.should == 1
    @c.keys.size.should == 5
  end

end
