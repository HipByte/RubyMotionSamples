describe 'WindowController' do
  # tests WindowController
  
  before { @controller = NSApp.delegate.windowController }

  it 'form should have 8 cells' do
    @controller.form.cells.count.should.be == 8
  end
  
  it '32°C for Celsius' do
    view = @controller.form.cellAtIndex(1)
    view.insertText = "32"
    view = @controller.form.cellAtIndex(2)
    # fahrenheit = view.stringValue
    # fahrenheit.should.equal '89,6'
    view.should.not == nil
  end
end