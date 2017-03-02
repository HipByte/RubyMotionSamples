module Escape
  class StartScene < CommonScene

    def touchesBegan(touches, withEvent:event)
      unless @_didTap        
        presentMainScene = SKAction.runBlock(-> {
          @_didTap = true
          gameScene = MainGameScene.sceneWithSize(self.size)
          # transition = SKTransition.pushWithDirection(SKTransitionDirectionUp, duration:1.0)
          doors = SKTransition.doorsOpenHorizontalWithDuration(1.0)
          # transition.pausesIncomingScene = true
          doors.pausesIncomingScene = true
          self.scene.view.presentScene(gameScene, transition:doors)
        })
        
        button = self.childNodeWithName('Start Button')
        if button
          moveSequence = animateStartbutton(button)
          button.runAction(moveSequence, completion:-> { 
            self.runAction(presentMainScene)
          })
        else
          self.runAction(presentMainScene)
        end
        
      end
    end


    def update(currentTime)
    end


    private

    def createSceneContents
      @_didTap = false

      self.backgroundColor = GAME_SCREEN_COLOR
      self.scaleMode = SKSceneScaleModeAspectFit

       gameNameLabel = SKLabelNode.labelNodeWithFontNamed('BankGothicBold').tap do |label|
         label.text = 'ESCAPE'
         label.name = 'Escape'
         label.fontSize = 42
         label.position = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100)
       end

       startLabel = SKLabelNode.labelNodeWithFontNamed('BankGothicBold').tap do |label|
         label.text = 'TAP TO START!'
         label.name = 'Start Button'
         label.fontSize = 20
         label.position = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100)
       end

       self.addChild(gameNameLabel)
       self.addChild(startLabel)
    end

    def animateStartbutton(startButton)
      startButton.name = nil
      SKAction.sequence([
        SKAction.moveByX(0, y:100.0, duration:0.2),
        SKAction.scaleTo(0.5, duration:0.2),
        SKAction.waitForDuration(0.1),
        SKAction.fadeOutWithDuration(0.1),
        SKAction.removeFromParent,
      ])
    end
  end
end
