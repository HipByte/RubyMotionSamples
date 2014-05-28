class HelloScene < SKScene
  attr_accessor :contentCreated

  def didMoveToView(view)
    unless contentCreated
      createSceneContents
      @contentCreated = true
    end
  end

  def createSceneContents
    self.backgroundColor = UIColor.blueColor
    self.scaleMode = SKSceneScaleModeAspectFit
    self.addChild newHelloNode
  end

  def newHelloNode
    helloNode = SKLabelNode.labelNodeWithFontNamed "Chalkduster"
    helloNode.name = "helloNode"
    helloNode.text = "Hello World!"
    helloNode.fontSize = 42
    helloNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
    helloNode
  end

  def touchesBegan(touches, withEvent: event)
    helloNode = self.childNodeWithName("helloNode")

    unless helloNode.nil?
      helloNode.name = nil
      moveUp = SKAction.moveByX(0, y: 100.0, duration: 0.5)
      zoom = SKAction.scaleTo(2.0, duration: 0.25)
      pause = SKAction.waitForDuration(0.5)
      fadeAway = SKAction.fadeOutWithDuration(0.25)
      remove = SKAction.removeFromParent
      moveSequence = SKAction.sequence [moveUp, zoom, pause, fadeAway, remove]
      helloNode.runAction(moveSequence, completion: lambda do
                            spaceshipScene = SpaceshipScene.alloc.initWithSize(self.size)
                            doors = SKTransition.doorsOpenVerticalWithDuration 0.5
                            self.view.presentScene(spaceshipScene, transition: doors)
                          end)
    end
  end
end
