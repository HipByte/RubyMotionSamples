class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    # Remove the following line if you don't want the status bar to be hidden
    UIApplication.sharedApplication.setStatusBarHidden(true, withAnimation:UIStatusBarAnimationFade)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = WebViewController.alloc.init
    @window.makeKeyAndVisible
    true
  end
end
