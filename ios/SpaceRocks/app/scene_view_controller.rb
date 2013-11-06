class SceneViewController < UIViewController
  def viewDidLoad
    super
    self.view = SceneView.alloc.init
  end

  def viewWillAppear(animated)
    hello = HelloScene.alloc.initWithSize(CGSizeMake(768,1024))
    self.view.presentScene hello
  end
end
