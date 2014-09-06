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
    view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    text_view = UITextView.alloc.initWithFrame(view.bounds)
    text_view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth
    view.addSubview(text_view)

    self.view = view
  end

end
