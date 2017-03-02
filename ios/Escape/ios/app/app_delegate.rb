module Escape
  class AppDelegate
    def application(application, willFinishLaunchingWithOptions:launchOptions)
      true
    end

    def application(application, didFinishLaunchingWithOptions:launchOptions)
      UIApplication.sharedApplication.setStatusBarHidden true
      mainViewController = MainViewController.alloc.init
      # mainViewController.edgesForExtendedLayout = UIRectEdgeNone
      mainViewController.wantsFullScreenLayout = true
      self.window.rootViewController = mainViewController
      self.window.makeKeyAndVisible
      true
    end

    def window
      @_window ||= UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    end

  end
end
