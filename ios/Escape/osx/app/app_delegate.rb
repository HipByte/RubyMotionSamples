class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    mainViewController = Escape::MainViewController.new
    mainViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    self.window.contentView.addSubview(mainViewController.view)
    self.window.acceptsMouseMovedEvents = true 
    self.window.makeFirstResponder(mainViewController.view.scene)
  end

  def buildWindow
    window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    window.orderFrontRegardless
  end

  def window
    @_window ||= NSWindow.alloc.initWithContentRect([[240, 180], Escape::SCREEN_FRAME.size], 
                                          styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask, 
                                            backing: NSBackingStoreBuffered, 
                                              defer: false)
  end
end
