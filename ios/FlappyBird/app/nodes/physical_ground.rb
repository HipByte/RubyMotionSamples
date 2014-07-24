class PhysicalGround < SKNode
  def init
    super

    self.position = CGPointMake(160, 56)
    self.physicsBody = SKPhysicsBody.bodyWithRectangleOfSize(CGSizeMake(320, 112))
    self.physicsBody.categoryBitMask = SkyLineScene::WORLD
    self.physicsBody.dynamic = false
    self
  end
end
