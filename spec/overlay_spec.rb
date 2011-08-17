require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::Overlay do

  before :each do
    settings = { :name => :an_overlay, :inputs => [:input1, :input2, :input3] } 
    @e = ConfigLogic::Overlay.new(settings)
    @e.set_input(:input1, {:a => 1})
    @e.set_input(:input2, {:b => 2})
    @e.set_input(:input3, {:a => 2, :c => 3})
  end

  it 'should initialize' do
    @e.should be_an_instance_of(ConfigLogic::Overlay)
    @e.should be_a_kind_of(ConfigLogic::LogicElement)
    @e.name.should == :an_overlay
    @e.inputs.should == {'input1' => {'a' => 1}, 
                         'input2' => {'b' => 2}, 
                         'input3' => {'a' => 2, 'c' => 3}}
  end

  it 'should output a propper overlay when all inputs are hashes' do
    @e.output.should == {'a' => 2, 'b' => 2, 'c' => 3}
  end

  it 'should output a propper overlay when not all inputs are hashes' do
    settings = { :name => :an_overlay, :inputs => [:input1, :input2, :input3] } 
    e = ConfigLogic::Overlay.new(settings)
    e.set_input(:input1, 1)
    e.set_input(:input2, {:a => 1})
    e.set_input(:input3, 3)
    e.output.should == 3
  end

end
