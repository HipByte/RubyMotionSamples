class GameViewController < UIViewController
  def loadView
    view = SKView.new
    view.showsFPS = true
    view.showsNodeCount = true
    view.showsDrawCount = true

    self.view = view
  end

  def prefersStatusBarHidden
    true
  end

  def viewWillLayoutSubviews
    super

    unless self.view.scene
      scene = SkyLineScene.alloc.initWithSize(view.bounds.size)
      scene.scaleMode = SKSceneScaleModeAspectFill
      view.presentScene scene
    end
  end
end
