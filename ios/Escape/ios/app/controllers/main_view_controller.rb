module Escape

  class MainViewController < UIViewController

    def loadView
      self.view = SKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      self.view.accessibilityLabel = 'Game View'
    end

    def viewDidLoad
      super
      ## FOR DEBUGGING pretty handy
      # self.view.showsDrawCount = true
      # self.view.showsNodeCount = true
      # self.view.showsFPS = true
    end


    def viewWillAppear(animated)
      # Configure the view
      scene = StartScene.sceneWithSize(self.view.bounds.size)
      scene.scaleMode = SKSceneScaleModeAspectFill

      # Present the scene.
      self.view.presentScene(scene)
    end


    def prefersStatusBarHidden
      true
    end


    def shouldAutorotate
      true
    end


    def supportedInterfaceOrientations
      Device.iphone? ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskAll
    end
  end

end
