describe 'ValueTransformer Newton to Kelvin' do

  before { @transformer = ValueTransformer::Newton.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Newton (373.13 K = 32.99340000000001 °N)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 32.98, 33
  end

  it 'reverse converts boiling point of water into Newton (373.13 K = 32.99340000000001 °N)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 32.98, 33
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.001)
  end
end