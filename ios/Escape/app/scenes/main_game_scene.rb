module Escape # GameScreen
  class MainGameScene < CommonScene

    attr_accessor :score

    def initWithSize(size)
      super
    end

    # Create and configure monster sprite
    def monster
      @monster ||= Monster.spriteNodeWithImageNamed('blockerMad').tap do |mo|
        mo.position = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame)+mo.size.height/2)
        mo.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(mo.size)
        mo.physicsBody.categoryBitMask = Category::MONSTER
        mo.physicsBody.contactTestBitMask = Category::WALL | Category::PLAYER
        mo.physicsBody.collisionBitMask = Category::WALL
      end      
    end

    # Create and configure player sprite
    def player
      @player ||= SKSpriteNode.spriteNodeWithImageNamed('hud_p1_opt').tap do |pl|
        pl.position = CGPoint.new(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        pl.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(pl.size)
        pl.physicsBody.categoryBitMask = Category::PLAYER
        pl.physicsBody.contactTestBitMask = Category::WALL | Category::MONSTER
        pl.physicsBody.collisionBitMask = Category::WALL
        pl.physicsBody.dynamic = true
        pl.physicsBody.usesPreciseCollisionDetection = true
        pl.physicsBody.velocity = CGVector.new(0, 0)
      end
    end

    # Create and configure wall boundaries
    def leftWall
      wallNamed(Wall::LEFT, ofSize:CGSize.new(10, @screenWindow.size.height)) do |wall|
        wall.position = CGPoint.new(CGRectGetMinX(self.frame), (wall.size.height/2))
      end
    end

    def rightWall
      wallNamed(Wall::RIGHT, ofSize:CGSize.new(10, @screenWindow.size.height)) do |wall|
        wall.position = CGPoint.new(CGRectGetMaxX(self.frame), (wall.size.height/2))
      end
    end

    def topWall
      wallNamed(Wall::TOP, ofSize:CGSize.new(@screenWindow.size.width, 10)) do |wall|
        wall.position = CGPoint.new(wall.size.width/2, CGRectGetMaxY(self.frame))
      end
    end

    def bottomWall
      wallNamed(Wall::BOTTOM, ofSize:CGSize.new(@screenWindow.size.width, 10)) do |wall|
        wall.position = CGPoint.new(wall.size.width/2, CGRectGetMinY(self.frame)*2)
      end
    end

    def scoreLabel
      @scoreLabel ||= SKLabelNode.labelNodeWithFontNamed('BankGothicBold').tap do |lb|
        # lb.fontColor = SKColor.blackColor
        lb.fontSize = 14;
        lb.text = "Score: #@score"
        lb.name = "Score"
        lb.position = CGPoint.new(CGRectGetMaxX(self.frame) - lb.frame.size.width, CGRectGetMinY(self.frame) + lb.frame.size.height)
      end
    end

    # Configure and run background music
    def backgroundMusicPlayer
      @backgroundMusicPlayer ||= begin
        error = Pointer.new(:object)
        musicURL = NSBundle.mainBundle.URLForResource('Endless Sand', withExtension:'mp3')
        audioPlayer = AVAudioPlayer.alloc.initWithContentsOfURL(musicURL, error:error)
        audioPlayer.volume = 0.2
        audioPlayer.numberOfLoops = -1
        audioPlayer.prepareToPlay
        audioPlayer
      end
    end

    def dragPlayer(gesture)
      if gesture.state == UIGestureRecognizerStateChanged
        # Get the (x,y) translation coordinate
        translation = gesture.translationInView(self.view)
        
        # Move by -y because moving positive is right and down, we want right and up
        # so that we can match the user's drag location (SKView rectangle y is opp UIView)
        newLocation = CGPoint.new(self.player.position.x + translation.x, self.player.position.y - translation.y)
        
        # Check if location is in bounds of screen
        self.player.position = checkBounds(newLocation)
        
        # Reset the translation point to the origin so that translation does not accumulate
        gesture.setTranslation(CGPoint.new, inView:self.view)
      end
    end

    def updateWithTimeSinceLastUpdate(timeSinceLast)
      @lastMoveTimeInterval += timeSinceLast
      @lastMoveTimeInterval = 0 if @lastMoveTimeInterval > 1
      
      # Update score
      self.score += 1
      self.scoreLabel.text = "Score: #@score"
      self.monster.score = self.score
      
      # Update the monster's state
      self.monster.updateWithTimeSinceLastUpdate(timeSinceLast)
      
      # Handle projectile throwing
      if self.score > 100 && self.monster.currentState == :throw
        self.shootProjectile
      end
    end

    def update(currentTime)
      
      timeSinceLast = currentTime - @lastUpdateTimeInterval
      @lastUpdateTimeInterval = currentTime
      
      # more than a second since last update
      if timeSinceLast > 1
        timeSinceLast = 1.0 / 60.0
        @lastUpdateTimeInterval = currentTime # ?????
      end

      self.updateWithTimeSinceLastUpdate(timeSinceLast)
    end

    def didBeginContact(contact)
      if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        firstBody, secondBody = contact.bodyA, contact.bodyB
      else
        firstBody, secondBody = contact.bodyB, contact.bodyA
      end

      # wall and Monster
      if firstBody.categoryBitMask & Category::WALL != 0 && secondBody.categoryBitMask & Category::MONSTER != 0
        self.monster.wallIdentifier = firstBody.node.name
        self.monster.endSeek
      end
      
      # Wall and Player
      if firstBody.categoryBitMask & Category::WALL != 0 && secondBody.categoryBitMask & Category::PLAYER != 0
        self.score = 0
      end
      
      # Monster and Player
      if firstBody.categoryBitMask & Category::MONSTER != 0 && secondBody.categoryBitMask & Category::PLAYER != 0
        self.removeAllActions
        self.gameOver
      end
      
      # Wall and Projectile
      if firstBody.categoryBitMask & Category::WALL != 0 && secondBody.categoryBitMask & Category::PROJECTILE != 0
        secondBody.node.removeFromParent
      end
      
      # Player and Projectile
      if firstBody.categoryBitMask & Category::PLAYER != 0 && secondBody.categoryBitMask & Category::PROJECTILE != 0
        self.removeAllActions
        self.gameOver
      end
      
    end

    def shootProjectile
      # Create and configure a projectile
      projectile = Projectile.spriteNodeWithImageNamed('blockerBodySmall').tap do |proj|
        proj.position = self.monster.position;
        proj.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(proj.size)
        proj.physicsBody.dynamic = true
        proj.physicsBody.usesPreciseCollisionDetection = true
        proj.physicsBody.categoryBitMask = Category::PROJECTILE
        proj.physicsBody.contactTestBitMask = Category::WALL | Category::PLAYER
        proj.physicsBody.collisionBitMask = 0
      end
      
      self.addChild(projectile)

      # Fire the projectile
      projectile.moveToSpriteNode(self.player)

      action = SKAction.rotateByAngle(380, duration: 0.2)
      finalAction = SKAction.repeatActionForever(action)
      projectile.runAction(finalAction)

      self.monster.resetState
    end

    def gameOver
      # Save the score and pass it to the game over screen
      self.userData = { score: self.score }
      gameOverScreen = GameOverScene.alloc.initWithSize(self.size, userData: self.userData)
      self.backgroundMusicPlayer.stop
      
      # Transition to new view
      transition = SKTransition.pushWithDirection(SKTransitionDirectionUp, duration:1.0)
      transition.pausesOutgoingScene = true
      self.view.presentScene(gameOverScreen, transition:transition)
    end

    private

    def checkBounds(newLocation)
      # This method will make sure the object is not outside of the bounds of the screen
      screenSize = self.size
      retValue = newLocation
      retValue.x = [retValue.x, LEFT_RIGHT_WALL_WIDTH].max
      retValue.x = [retValue.x, screenSize.width - LEFT_RIGHT_WALL_WIDTH].min
      retValue.y = [retValue.y, TOP_BOTTOM_WALL_HEIGHT].max
      retValue.y = [retValue.y, screenSize.height - TOP_BOTTOM_WALL_HEIGHT].min
      retValue
    end

    def createSceneContents
      @lastMoveTimeInterval = 0
      @lastUpdateTimeInterval = 0
      self.score = 0
      
      # Separate method to configure all of the scene to reduce overhead upon initialization
      # Set up physics world and background
      self.backgroundColor = GAME_SCREEN_COLOR
      self.scaleMode = SKSceneScaleModeAspectFit
      self.physicsWorld.contactDelegate = self
      self.anchorPoint = CGPoint.new(0.0, 0.0)
      self.physicsWorld.gravity = CGVector.new(0.0, 0.0) # No gravity
      
      # set monster target to player
      self.monster.target = self.player
      
      # Get bounds of device screen
      # to get it running on OSX and iOS
      if defined?(UIScreen)
        @screenWindow = UIScreen.mainScreen.bounds
      elsif defined?(NSApplication)
        @screenWindow = NSApplication.sharedApplication.delegate.window.contentView.bounds
      end
      
      self.monster.screenSize = @screenWindow.size
      
      # Add nodes to scene
      self.addChild(self.monster)
      self.addChild(self.player)
      self.addChild(self.leftWall)
      self.addChild(self.topWall)
      self.addChild(self.rightWall)
      self.addChild(self.bottomWall)
      self.addChild(self.scoreLabel)
      
      # Configure the pan gesture (dragging finger across the screen) 
      # to track and drag the player sprite accordingly
      @panGesture ||= UIPanGestureRecognizer.alloc.initWithTarget(self, action:'dragPlayer:').tap do |gesture|
        gesture.minimumNumberOfTouches = 1
        gesture.delegate = self
        self.view.addGestureRecognizer(gesture)
      end if defined?(UIPanGestureRecognizer)
      
      # Configure and run background music
      self.backgroundMusicPlayer.play
    end

    def wallNamed(wallName, ofSize:size)
      var_name = wallName[0].downcase + wallName[1, wallName.length - 1].gsub(/\s/, '')
      instance_variable_get("@#{var_name}") || 
      instance_variable_set("@#{var_name}", SKSpriteNode.spriteNodeWithColor(SKColor.blackColor, size:size)).tap do |wall|

        yield(wall) if block_given?

        wall.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(wall.size)
        wall.physicsBody.categoryBitMask = Category::WALL
        wall.physicsBody.contactTestBitMask = Category::MONSTER | Category::PLAYER
        wall.physicsBody.collisionBitMask = Category::PLAYER
        wall.physicsBody.dynamic = false
        wall.physicsBody.resting = true        
        wall.name = wallName
      end
    end

  end
end