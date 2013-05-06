class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    storyboard = UIStoryboard.storyboardWithName("Master", bundle:nil)
    rootVC = storyboard.instantiateViewControllerWithIdentifier("Main")

    @window.rootViewController = rootVC
    @window.makeKeyAndVisible
    true
  end
end
