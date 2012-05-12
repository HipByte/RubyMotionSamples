class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    tabbar = UITabBarController.alloc.init
    beer_list_controller = BeerListController.alloc.init(beer_details_controller)
    tabbar.viewControllers = [BeerMapController.alloc.init, beer_list_controller]
    tabbar.selectedIndex = 0
    @window.rootViewController = UINavigationController.alloc.initWithRootViewController(tabbar)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    return true
  end

  def beer_details_controller
    @beer_details_controller ||= BeerDetailsController.alloc.init
  end
end
