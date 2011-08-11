require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::LogicElement do

  before :each do
    settings = {:name => :a_logic_element}
    @e = ConfigLogic::LogicElement.new(settings)
  end

  it 'should initialize correctly' do
    @e.should be_an_instance_of(ConfigLogic::LogicElement)
    @e.name.should == :a_logic_element
    @e.static?.should == true
  end

  it 'should set input values' do
    @e.set_input(:a, 1)
    @e.set_input(:b, 2)
    @e.set_input(:c, 3)
    @e.inputs.should == {'a' => 1, 'b' => 2, 'c' => 3}
  end

  it 'should specify the minimum input number' do
    @e.class.min_inputs.should == 2
    @e.min_inputs.should == 2
  end

  it 'should determine if the input state is valid' do
    @e.send(:inputs_valid?).should == false
    @e.instance_variable_set('@inputs', {'a' => 1, 'b' => 2})
    @e.send(:inputs_valid?).should == true
  end

  it 'should respond with all registered component types' do
    (@e.class.available_elements - ['multiplexer', 'overlay']).should == []
  end

  it 'should convert element name to type' do
    @e.class.name_to_type('multiplexer').should == ConfigLogic::Multiplexer
    @e.class.name_to_type('overlay').should == ConfigLogic::Overlay
  end

end
