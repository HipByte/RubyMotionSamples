describe 'ValueTransformer Réaumur to Kelvin' do

  before { @transformer = ValueTransformer::Reaumur.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Réaumur (373.13 K = 79.98400000000001 °Ré)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 79.97, 79.98
  end

  it 'reverse converts boiling point of water into Réaumur (373.13 K = 79.98400000000001 °Ré)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 79.97, 79.98
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.001)
  end
end