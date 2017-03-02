describe Escape::GameOverScene do

  behaves_like 'Scene'

  before do
    @view = SKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @scene = Escape::GameOverScene.alloc.initWithSize(@view.bounds.size, userData: {score: 10})
    @view.presentScene(@scene)
  end

  it 'First Scene should have 4 Nodes' do
    @scene.children.count.should == 4
  end

  it "should have a Node named 'GAME OVER'" do
    @scene.should have_child_named?('GAME OVER')
  end

  it "should have a Node named 'SCORE:'" do
    @scene.should have_child_named?('SCORE:')
  end

  it "should have a Node named 'TAP TO PLAY AGAIN!'" do
    @scene.should have_child_named?('TAP TO PLAY AGAIN!')
  end

  it "should have a Node named [Score=10]" do
    @scene.should have_child_named?('10')
  end
  
  it 'should play background music' do
    @scene.backgroundMusicPlayer.playing?.should.be == true
  end

end