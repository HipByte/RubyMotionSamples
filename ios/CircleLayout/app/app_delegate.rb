class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = ViewController.alloc.initWithCollectionViewLayout(CircleLayout.new)
    @window.makeKeyAndVisible
    true
  end
end
