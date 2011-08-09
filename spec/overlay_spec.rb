require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::Overlay do

  before :each do
    settings = { :name => :an_overlay,
                 :inputs => [:key1, :key2, :key3] }

    @e = ConfigLogic::Overlay.new(settings)
  end

  it 'should initialize correctly' do
    @e.should be_an_instance_of(ConfigLogic::Overlay)
    @e.should be_a_kind_of(ConfigLogic::LogicElement)
    @e.name.should == :an_overlay
    @e.inputs.should == [:key1, :key2, :key3]
  end

  it 'should output a propper overlay when all inputs are hashes' do
    settings = { :name => :a_logic_element, :inputs => [{:a => 1}, {:b => 2}, {:a => 2, :c => 3}] }
    e = ConfigLogic::Overlay.new(settings)
    e.output.should == {:a => 2, :b => 2, :c => 3}
  end

  it 'should output a propper overlay when not all inputs are hashes' do
    @e.output.should == :key3
  end

end
