describe Escape::StartScene do

  behaves_like 'Scene'

  before do 
    @view = SKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @scene = Escape::StartScene.sceneWithSize(@view.bounds.size) 
    @view.presentScene(@scene)
  end
    

  it 'First Scene should have 2 Nodes' do
    @scene.children.count.should == 2
  end

  it 'should have a Title Node ESCAPE,' do
    @scene.should have_child_named?('Escape')
  end

  it 'should have a Start Button Node' do
    @scene.should have_child_named?('Start Button')
  end

end