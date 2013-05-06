class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect(NSMakeRect(240, 180, 401, 397),
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']

    @circle_view = CircleView.alloc.initWithFrame(NSMakeRect(24, 113, 357, 264))
    @circle_view.setAutoresizingMask(NSViewWidthSizable|NSViewHeightSizable)
    @mainWindow.contentView.addSubview(@circle_view)

    slider1 = NSSlider.alloc.initWithFrame(NSMakeRect(22, 79, 275, 21))
    slider1.setAction("takeRadiusFrom:")
    slider1.setTarget(@circle_view)
    slider1.setMinValue(1)
    slider1.setMaxValue(400)
    slider1.setIntValue(115)
    slider1.setAutoresizingMask(NSViewWidthSizable)
    @mainWindow.contentView.addSubview(slider1)

    slider2 = NSSlider.alloc.initWithFrame(NSMakeRect(22, 51, 275, 21))
    slider2.setAction("takeStartingAngleFrom:")
    slider2.setTarget(@circle_view)
    slider2.setMinValue(0)
    slider2.setMaxValue(6.28)
    slider2.setFloatValue(1.6)
    slider2.setAutoresizingMask(NSViewWidthSizable)
    @mainWindow.contentView.addSubview(slider2)

    color_well = NSColorWell.alloc.initWithFrame(NSMakeRect(328, 75, 53, 30))
    color_well.setColor(NSColor.blackColor)
    color_well.setAction("takeColorFrom:")
    color_well.setTarget(@circle_view)
    color_well.setAutoresizingMask(NSViewMinXMargin)
    @mainWindow.contentView.addSubview(color_well)

    button = NSButton.alloc.initWithFrame(NSMakeRect(323, 43, 63, 28))
    button.setTitle("Spin")
    button.setAction("toggleAnimation:")
    button.setTarget(@circle_view)
    button.setBezelStyle(NSRoundedBezelStyle)
    button.setAutoresizingMask(NSViewMinXMargin)
    @mainWindow.contentView.addSubview(button)

    text = NSTextField.alloc.initWithFrame(NSMakeRect(24, 15, 358, 22))
    text.setStringValue("Here's to the crazy ones, the misfits, the rebels, the troublemakers, the round pegs in the square holes, the ones who see things differently.")
    text.setAction("takeStringFrom:")
    text.setTarget(@circle_view)
    text.setAutoresizingMask(NSViewWidthSizable)
    @mainWindow.contentView.addSubview(text)

    @mainWindow.orderFrontRegardless
  end
end
