describe 'ValueTransformer Fahrenheit to Kelvin' do

  before { @transformer = ValueTransformer::Fahrenheit.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Fahrenheit (99.98°C = 373.13°K = 211.964°F)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 210.0, 212.0
  end

  it 'reverse converts boiling point of water into Fahrenheit (99.98°C = 373.13°K = 211.964°F)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 210.0, 212.0
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.1)
  end
end