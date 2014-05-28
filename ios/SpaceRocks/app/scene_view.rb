class SceneView < SKView
  def init
    super
    self.showsDrawCount = true
    self.showsNodeCount = true
    self.showsFPS = true
    self
  end
end
