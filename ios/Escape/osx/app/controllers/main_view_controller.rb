module Escape
  class MainViewController < NSViewController
    
    def loadView
      self.view = SKView.alloc.initWithFrame(SCREEN_FRAME)
      viewDidLoad
    end

    def viewDidLoad
      ## FOR DEBUGGING pretty handy
      # self.view.showsDrawCount = true
      # self.view.showsNodeCount = true
      # self.view.showsFPS = true

      # Configure the view
      scene = StartScene.sceneWithSize(self.view.bounds.size)
      scene.scaleMode = SKSceneScaleModeAspectFill

      # Present the scene.
      self.view.presentScene(scene)
    end

  end
end
