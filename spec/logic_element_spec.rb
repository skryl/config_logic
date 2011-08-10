require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::LogicElement do

  before :each do
    settings = {:name => :a_logic_element}
    @e = ConfigLogic::LogicElement.new(settings)
  end

  it 'should have proper accessors' do
    @e.should respond_to(:name)
    @e.should respond_to(:inputs)
  end

  it 'should initialize correctly' do
    @e.should be_an_instance_of(ConfigLogic::LogicElement)
    @e.name.should == :a_logic_element
  end

  it 'should announce the minimum input number' do
    @e.class.min_inputs.should == 2
  end

end
