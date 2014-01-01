describe 'ValueTransformer Delisle to Kelvin' do

  before { @transformer = ValueTransformer::Delisle.new }  

  behaves_like 'ValueTransformer'

  it 'converts boiling point of water into Delisle (373.13 K = 0.029999999999972715 °D)' do
    kelvin_value = 373.13
    @transformer.transformedValue(kelvin_value).should.be.close 0.028, 0.030
  end

  it 'reverse converts boiling point of water into Delisle (373.13 K = 0.029999999999972715 °D)' do
    kelvin_value = 373.13
    value = @transformer.transformedValue(kelvin_value)
    value.should.be.close 0.028, 0.030
    @transformer.reverseTransformedValue(value).should.be.close kelvin_value, (kelvin_value + 0.001)
  end
end