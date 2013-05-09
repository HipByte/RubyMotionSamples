class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    
    @window.backgroundColor = UIColor.whiteColor
    @window.makeKeyAndVisible()
    
    viewController = MotionGLController.alloc.initWithNibName(nil, bundle:nil)
    @window.addSubview(viewController.view)
    viewController.preferredFramesPerSecond = 60
    @window.rootViewController = viewController    
    true
  end
  
  
end
