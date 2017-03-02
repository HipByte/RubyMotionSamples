module Escape # Projectile

  class Projectile < SKSpriteNode

    def moveToSpriteNode(target)
      # Get vector from projectile to target
      targetVector = Vector.subtract(target.position, self.position)

      # Add a random x and y coordinate to the projectile path in order
      # to confuse the user and end their game faster
      randomizer = Random.new
      
      x = 8 * randomizer.rand(-25..51)
      y = 5 * randomizer.rand(-25..51)

      randomVector = CGPoint.new(targetVector.x + x, targetVector.y + y)

      # make unit vector
      direction = Vector.normalize(randomVector)

      # May cause glitches
      shootAmount = Vector.multiply(direction, withScalar:self.scene.size.height + self.scene.size.width)
      actualDistance = Vector.add(shootAmount, self.position)

      velocity = 200.0 / 1.0
      time = self.scene.size.width / velocity

      actionMove = SKAction.moveTo(actualDistance, duration:time)
      self.runAction(actionMove)
    end

  end
end
