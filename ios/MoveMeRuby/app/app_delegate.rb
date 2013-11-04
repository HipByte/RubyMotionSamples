class AppDelegate

  def application(application, didFinishLaunchingWithOptions: launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = MoveMeViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end

end
