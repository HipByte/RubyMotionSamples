describe 'ValueTransformer Celsius to Kelvin' do

  before { @transformer = ValueTransformer::Celsius.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Kelvin (99.98°C = 373.13°K)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 99.97, 99.99
  end

  it 'reverse converts boiling point of water into Kelvin (99.98°C = 373.13°K)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 99.97, 99.99
    @transformer.reverseTransformedValue(value).should == kelvin_value
  end
end