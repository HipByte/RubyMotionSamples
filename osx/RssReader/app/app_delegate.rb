class AppDelegate
  attr_reader :window

  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow

    @controller = RssReaderController.new
  end

  def buildWindow
    @window = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @window.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @window.orderFrontRegardless
  end
end
