require File.join(File.dirname(__FILE__), "spec_helper.rb")

describe ConfigLogic::Multiplexer do

  before :each do
    settings = { :name => :a_multiplexer,
                 :selector => Proc.new { :b },
                 :input_names => [:a, :b, :c],
                 :inputs => [1, 2, 3] }

    @m = ConfigLogic::Multiplexer.new(settings)
  end

  it 'should initialize correctly' do
    @m.should be_an_instance_of(ConfigLogic::Multiplexer)
    @m.should be_a_kind_of(ConfigLogic::LogicElement)
    @m.name.should == :a_multiplexer
    @m.inputs.should == {:a => 1, :b => 2, :c => 3}
  end

  it 'should have proper accessors' do
    @m.should respond_to(:selector)
  end

  it 'should correctly multiplex outputs based on selector' do
    @m.output.should == 2
  end

end
