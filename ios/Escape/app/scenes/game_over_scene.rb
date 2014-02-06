module Escape # GameOverScene
  class GameOverScene < CommonScene

    def initWithSize(sceneSize, userData:userData)
      initWithSize(sceneSize).tap do |newScene|
        self.userData = userData
        @_didTap = false
      end
    end

    attr_accessor :score

    def touchesBegan(touches, withEvent:event)
      unless @_didTap #  Called when user taps screen
        presentMainScene = SKAction.runBlock(-> {
          @_didTap = true
          gameScene = MainGameScene.sceneWithSize(self.size)
          transition = SKTransition.pushWithDirection(SKTransitionDirectionUp, duration:1.0)
          backgroundMusicPlayer.stop
          transition.pausesIncomingScene = true
          self.scene.view.presentScene(gameScene, transition:transition)
        })

        self.runAction(presentMainScene)
      end
    end


    def backgroundMusicPlayer
      @backgroundMusicPlayer ||= begin
        error = Pointer.new(:object)
        musicURL = NSBundle.mainBundle.URLForResource('8-bit loop (loop)', withExtension:'mp3')
        audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(musicURL, error:error)
        audioPlayer.volume = 0.2
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay
        audioPlayer
      end
    end


    private


    def createSceneContents
      # Start background music      
      backgroundMusicPlayer.play

      # Configure background color
      self.backgroundColor = GAME_SCREEN_COLOR
      self.scaleMode = SKSceneScaleModeAspectFit

      # Display labels
      self.score = self.userData[:score]

      labelPosition = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 200)
      firstLabel = createLabel('GAME OVER', fontSize:42, position:labelPosition)
      # firstLabel.fontColor = SKColor.blackColor
      
      labelPosition = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 35)
      secondLabel = createLabel('SCORE:', fontSize:28, position:labelPosition)

      labelPosition = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - 175)
      thirdLabel = createLabel('TAP TO PLAY AGAIN!', fontSize:16, position:labelPosition)
      
      labelPosition = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
      fourthLabel = createLabel("#{self.score}", fontSize:36, position:labelPosition)

      self.addChild(firstLabel)
      self.addChild(secondLabel)
      self.addChild(thirdLabel)
      self.addChild(fourthLabel)
    end


    def createLabel(text, fontSize:fontSize, position:position)
      SKLabelNode.labelNodeWithFontNamed('BankGothicBold').tap do |label|
        label.text = text
        label.name = text
        label.fontSize = fontSize
        label.position = position
      end
    end
    
  end
end
