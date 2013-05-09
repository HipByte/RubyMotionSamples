class HelloViewController < UIViewController
  def loadView
    self.view = HelloView.alloc.init
  end
end
