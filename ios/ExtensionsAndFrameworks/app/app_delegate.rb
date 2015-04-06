class AppDelegate
  include MyFrameworkModule

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    MyFrameworkClass.say_hello
    say_hello # Included from the module

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = MyController.new
    @window.rootViewController = ctlr
    @window.makeKeyAndVisible

    true
  end
end


class MyController < UIViewController

  def loadView
    screen_rect = UIScreen.mainScreen.bounds
    rect = [[screen_rect.origin.x, screen_rect.origin.y + 22],[screen_rect.size.width, screen_rect.size.height - 22]]
    view = UIView.alloc.initWithFrame(rect)
    view.backgroundColor = UIColor.whiteColor
    @text_view = UITextView.alloc.initWithFrame(view.frame)
    @text_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    view.addSubview(@text_view)

    self.view = view
  end

  def viewDidAppear(animated)
    @text_view.becomeFirstResponder
  end

end
