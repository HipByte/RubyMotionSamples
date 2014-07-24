class PipePair < SKNode
  def init
    super

    self.position = CGPointMake(400, 0)
    self.zPosition = -10
    self.name = "pipes"
    self.addChild(top)
    self.addChild(bottom)
    self.runAction(move_and_remove)
    self
  end

  def top
    pipe_up = Pipe.alloc.init("pipe_down.png")
    pipe_up.position = CGPointMake(0, random_y + 450)
    pipe_up
  end

  def bottom
    pipe_down = Pipe.alloc.init("pipe_up.png")
    pipe_down.position = CGPointMake(0, random_y)
    pipe_down
  end

  def random_y
    @y ||= Random.new.rand 0.0..(150.0)
  end

  def move_and_remove
    distance = 520
    move_pipes = SKAction.moveByX(-distance, y: 0, duration: 0.02 * distance)
    remove_pipes = SKAction.removeFromParent

    SKAction.sequence([move_pipes, remove_pipes])
  end
end
