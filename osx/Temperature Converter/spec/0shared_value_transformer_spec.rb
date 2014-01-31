shared 'ValueTransformer' do
  it 'is allowed to reserve transform' do
    @transformer.class.allowsReverseTransformation.should.be.true
  end
  
  it 'its transformed value class is NSNumber' do
    @transformer.class.transformedValueClass.should.be == NSNumber
  end
end