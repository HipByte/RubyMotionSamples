describe Escape::MainGameScene do

  behaves_like 'Scene'

  before do
    @view = SKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @scene = Escape::MainGameScene.sceneWithSize(@view.bounds.size)
    @view.presentScene(@scene)
  end

  it 'First Scene should have 7 Nodes' do
    @scene.children.count.should == 7
  end

  it "should have a Node named #{Escape::Wall::LEFT}" do
    @scene.should have_child_named?(Escape::Wall::LEFT)
  end

  it "should have a Node named #{Escape::Wall::RIGHT}" do
    @scene.should have_child_named?(Escape::Wall::RIGHT)
  end

  it "should have a Node named #{Escape::Wall::TOP}" do
    @scene.should have_child_named?(Escape::Wall::TOP)
  end

  it "should have a Node named #{Escape::Wall::BOTTOM}" do
    @scene.should have_child_named?(Escape::Wall::BOTTOM)
  end

  it "should have a Node named Score" do
    @scene.should have_child_named?('Score')
  end

  it 'should play background music' do
    @scene.backgroundMusicPlayer.playing?.should.be == true
  end

end