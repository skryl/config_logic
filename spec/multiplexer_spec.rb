require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::Multiplexer do

  before :each do
    settings = { :name => :a_multiplexer,
                 :selector => Proc.new { 1 + 1 },
                 :inputs => {1 => :a, 2 => :b, 3 => :c} }
    @m = ConfigLogic::Multiplexer.new(settings)
    @m.set_input(:a, 10)
    @m.set_input(:b, 11)
    @m.set_input(:c, 12)
  end

  it 'should initialize correctly' do
    @m.should be_an_instance_of(ConfigLogic::Multiplexer)
    @m.should be_a_kind_of(ConfigLogic::LogicElement)
    @m.name.should == :a_multiplexer
    @m.inputs.should == {'a' => 10, 'b' => 11, 'c' => 12}
    @m.instance_variable_get('@multiplexer').should == {1 => :a, 2 => :b, 3 => :c}
  end

  it 'should have proper accessors' do
    @m.should respond_to(:selector)
  end

  it 'should correctly multiplex outputs based on selector' do
    @m.output.should == 11
  end

end
