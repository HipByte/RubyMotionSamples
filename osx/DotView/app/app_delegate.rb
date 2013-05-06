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

    # Build the drawing view.
    dot_view = DotView.alloc.initWithFrame(NSMakeRect(24, 61, 357, 264))
    dot_view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    @mainWindow.contentView.addSubview(dot_view)

    # Build the slider.
    slider = NSSlider.alloc.initWithFrame(NSMakeRect(21, 23, 275, 21))
    slider.action= :"setRadius:"
    slider.target = dot_view
    slider.minValue = 1
    slider.maxValue = 400
    slider.intValue = 10
    slider.autoresizingMask = NSViewMaxYMargin|NSViewWidthSizable
    @mainWindow.contentView.addSubview(slider)

    # Build the color well button.
    color_well = NSColorWell.alloc.initWithFrame(NSMakeRect(328, 20, 53, 30))
    color_well.color = NSColor.redColor
    color_well.action = :"setColor:"
    color_well.target = dot_view
    color_well.autoresizingMask = NSViewMinXMargin|NSViewMaxYMargin
    @mainWindow.contentView.addSubview(color_well)

    @mainWindow.orderFrontRegardless
  end
end
