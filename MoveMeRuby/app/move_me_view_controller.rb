class MoveMeViewController < UIViewController

  def loadView
    super
    self.view = MoveMeView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
  end

end
