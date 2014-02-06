module Escape # Monster

  # states => :idle | :walking | :seek | :throw
  class Monster < SKSpriteNode

    def initWithImageNamed(name)
      super.tap do
        @score = 0
        @currentState = :idle
      end
    end

    def moveToSpriteNode(target, withTimeInterval:time)
      if @currentState == :idle
        targetVector = Vector.subtract(target.position, self.position)

        unitizedVector = Vector.normalize(targetVector)

        shootAmt = Vector.multiply(unitizedVector, withScalar:self.screenSize.height + self.screenSize.width)

        actualDistance = Vector.add(shootAmt, self.position)

        moveAction = SKAction.moveTo(actualDistance, duration:time)

        self.runAction(moveAction)

        @currentState = :seek
      end
    end


    def endSeek
      self.removeAllActions
      self.chooseNextAction
    end


    def chooseNextAction
      if randomizer(1..3) <= 1 # 67 % chance to walk        
        @currentState = :walk
        self.monsterWalk
      else        
        if self.score >= 0 && Random.rand(1).zero? # 100% chance to throw projectile (33% overall)          
          self.shootProjectile
        end
      end
    end


    def resetState
      @currentState = :idle
    end


    def shootProjectile
      @currentState = :throw
    end


    def monsterWalk
      multiplier = 1.5
      if @currentState == :walk
        randomInterval = Random.rand * multiplier # Time between 0 and 1.5s

        # Decide magnitude of walk
        walkDistance = randomizer(-80..80)

        # Decide direction of walk depending on the current wall
        if self.wallIdentifier == Wall::LEFT || self.wallIdentifier == Wall::RIGHT
          wallVertical = SKAction.moveByX(0, y:walkDistance, duration:randomInterval)
          resetState = SKAction.performSelector(:resetState, onTarget:self)
          self.runAction SKAction.sequence([wallVertical, resetState])

        elsif self.wallIdentifier == Wall::BOTTOM || self.wallIdentifier == Wall::TOP
          walkHorizontal = SKAction.moveByX(walkDistance, y:0, duration:randomInterval)
          resetState = SKAction.performSelector(:resetState, onTarget:self)
          self.runAction SKAction.sequence([walkHorizontal, resetState])
        end
      end
    end


    def updateWithTimeSinceLastUpdate(timeSinceLast)      
      if self.score >= 100
        time = if self.score <= 1000
          Random.rand + 2.0
        elsif self.score.between?(1000, 3000)
          Random.rand + 1.5
        elsif self.score.between?(3000, 5000) 
          Random.rand + 1.0
        else
          Random.rand + 0.7
        end

        if @currentState == :idle
          self.moveToSpriteNode(self.target, withTimeInterval:time)
        end
        
      end
    end


    attr_accessor :screenSize, :target, :score, :wallIdentifier
    attr_reader :currentState


    private

    def randomizer(range)
      @randomizer ||= Random.new
      @randomizer.rand(range)
    end
  end

end
