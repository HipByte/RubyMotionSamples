describe 'ValueTransformer Rankine to Kelvin' do

  before { @transformer = ValueTransformer::Rankine.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Rankine (373.13 K = 671.634 °R)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 671.6, 671.7
  end

  it 'reverse converts boiling point of water into Rankine (373.13 K = 671.634 °R)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 671.6, 671.7
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.1)
  end
end