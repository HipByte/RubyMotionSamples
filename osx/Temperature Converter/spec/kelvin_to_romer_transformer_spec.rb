describe 'ValueTransformer Rømer to Kelvin' do

  before { @transformer = ValueTransformer::Romer.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Rømer (373.13 K = 59.98950000000001 °Rø)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 59.97, 59.99
  end

  it 'reverse converts boiling point of water into Rømer (373.13 K = 59.98950000000001 °Rø)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 59.97, 59.99
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.001)
  end
end