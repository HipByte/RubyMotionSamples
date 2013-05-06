class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect(NSMakeRect(240, 180, 405, 345),
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']

    dot_view = DotView.alloc.initWithFrame(NSMakeRect(24, 61, 357, 264))
    dot_view.setAutoresizingMask(NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable)
    @mainWindow.contentView.addSubview(dot_view)

    slider = NSSlider.alloc.initWithFrame(NSMakeRect(21, 23, 275, 21))
    slider.setAction("setRadius:")
    slider.setTarget(dot_view)
    slider.setMinValue(1)
    slider.setMaxValue(400)
    slider.setIntValue(10)
    slider.setAutoresizingMask(NSViewWidthSizable)
    @mainWindow.contentView.addSubview(slider)

    color_well = NSColorWell.alloc.initWithFrame(NSMakeRect(328, 20, 53, 30))
    color_well.setColor(NSColor.redColor)
    color_well.setAction("setColor:")
    color_well.setTarget(dot_view)
    color_well.setAutoresizingMask(NSViewMaxXMargin|NSViewMaxYMargin)
    @mainWindow.contentView.addSubview(color_well)

    @mainWindow.orderFrontRegardless
  end
end
