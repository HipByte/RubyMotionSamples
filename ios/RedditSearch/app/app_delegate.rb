class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    @window.rootViewController = RedditController.alloc.initWithStyle(UITableViewStylePlain)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    true
  end
end
