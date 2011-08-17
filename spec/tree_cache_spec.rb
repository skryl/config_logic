require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::TreeCache do

  before :each do
    @c = ConfigLogic::TreeCache.new(CONFIG_DIR)
  end

  it 'should initialize' do
    @c.should be_an_instance_of(ConfigLogic::TreeCache)
  end

  it 'should build a valid tree cache' do
    @c.to_hash.keys.sort.should == ['config1', 'config2', 'config3', 'dir1', 'dir4']
  end

  it 'should rebuild cache during a reload!' do
    config_dir = "#{CONFIG_DIR}/dir1"
    @c.instance_variable_set('@load_paths', [config_dir])
    @c.reload!
    @c.to_hash.keys.sort.should == ['config1', 'config2', 'config3']
  end

  it 'should apply global overlay elements' do
    @c = ConfigLogic::TreeCache.new(CONFIG_DIR, :overlays => [{:name => :over, :inputs => [:key1, :key2, :key3]}] )
    overlayed_result = {"nestedkey1" => 1, "nestedkey2" => 2, "nestedkey3" => 3,
                        "nestedkey4" => 4, "nestedkey5" => 5, "nestedkey6" => 6,
                        "nestedkey7" => 7, "nestedkey8" => 8, "nestedkey9" => 9}
    @c[:dir1][:config1][:over].to_hash.should == overlayed_result
    @c[:dir1][:config2][:over].to_hash.should == overlayed_result
    @c[:dir1][:config3][:over].to_hash.should == overlayed_result
    @c[:dir1][:config3].keys.size.should == 1
    @c[:config1][:over].to_hash.should == overlayed_result
    @c[:config2][:over].to_hash.should == overlayed_result
    @c[:config3][:over].to_hash.should == overlayed_result
    @c[:config3].keys.size.should == 1
  end

  it 'should apply global multiplexer elements' do
    @c = ConfigLogic::TreeCache.new(CONFIG_DIR, :multiplexers => [{:name => :multi, :selector => 1, :inputs => {1 => :config1, 2 => :config2, 3 => :config3}}])
    multiplexed_result = {"key1"=>{"nestedkey1"=>1, "nestedkey2"=>2, "nestedkey3"=>3},
                          "key2"=>{"nestedkey4"=>4, "nestedkey5"=>5, "nestedkey6"=>6},
                          "key3"=>{"nestedkey7"=>7, "nestedkey8"=>8, "nestedkey9"=>9}} 
    @c[:dir1][:multi].to_hash.should == multiplexed_result
    @c[:dir1].keys.size.should == 1
    @c[:multi].to_hash.should == multiplexed_result
    @c.keys.size.should == 3
  end

  it 'should return node at any path' do
    @c[:dir1, :config1, :key1, :nestedkey1].should == 1
    @c[:dir1].should be_a_kind_of(Hash)
    @c[:dir1, :config1, :key1].should be_a_kind_of(Hash)
  end

end
