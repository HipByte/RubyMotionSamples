describe Escape::MainViewController do

  tests Escape::MainViewController

  def instance_of?(klass)
    lambda { |obj| obj.class == klass }
  end

  it 'the view is a spriteKit view [SKView]' do
    controller.view.should.be.a instance_of?(SKView)
  end

  it 'shows the start [Game scene]' do
    controller.view.scene.should.be.a instance_of?(Escape::StartScene)
  end

  it 'after a tap should move to [Main Game scene]' do
    tap 'Game View'
    wait 2.0 do
      controller.view.scene.should.be.a instance_of?(Escape::MainGameScene)
    end
  end

  it 'once killed should move to [Game Over scene]' do
    tap 'Game View'
    wait 3.5 do
      controller.view.scene.should.be.a instance_of?(Escape::GameOverScene)
    end
  end
end