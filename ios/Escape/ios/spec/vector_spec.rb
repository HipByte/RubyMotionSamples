describe Escape::Vector do
  before do
    @firstPoint  = CGPoint.new(10, 10);
    @secondPoint = CGPoint.new(20, 20);
  end

  it '::normalize' do
    normalized = Escape::Vector.normalize(@firstPoint)
    normalized.x.should.be.close? 0.70, 0.71
    normalized.y.should.be.close? 0.70, 0.71
    normalized.should == CGPoint.new(0.70710678118654746, 0.70710678118654746)
  end
  
  it '::multiply:withScalar:' do
    multiply = Escape::Vector.multiply(@firstPoint, withScalar:10.0)
    multiply.should == CGPoint.new(100, 100)
  end
  
  it '::subtract' do
    subtraction = Escape::Vector.subtract(@firstPoint, @secondPoint)
    subtraction.should == CGPoint.new(-10, -10)
  end
  
  it '::add' do
    addition = Escape::Vector.add(@firstPoint, @secondPoint)
    addition.should == CGPoint.new(30, 30)
  end
end
