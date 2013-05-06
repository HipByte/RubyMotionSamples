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
    slider1.action = :"takeRadiusFrom:"
    slider1.target = @circle_view
    slider1.minValue = 1 
    slider1.maxValue = 400 
    slider1.intValue = 115 
    slider1.autoresizingMask = NSViewWidthSizable
    @mainWindow.contentView.addSubview(slider1)

    slider2 = NSSlider.alloc.initWithFrame(NSMakeRect(22, 51, 275, 21))
    slider2.action = :"takeStartingAngleFrom:" 
    slider2.target = @circle_view 
    slider2.minValue = 0 
    slider2.maxValue = 6.28 
    slider2.floatValue = 1.6 
    slider2.autoresizingMask = NSViewWidthSizable 
    @mainWindow.contentView.addSubview(slider2)

    color_well = NSColorWell.alloc.initWithFrame(NSMakeRect(328, 75, 53, 30))
    color_well.color = NSColor.blackColor 
    color_well.action = :"takeColorFrom:" 
    color_well.target = @circle_view 
    color_well.autoresizingMask = NSViewMinXMargin 
    @mainWindow.contentView.addSubview(color_well)

    button = NSButton.alloc.initWithFrame(NSMakeRect(323, 43, 63, 28))
    button.title = "Spin" 
    button.action = "toggleAnimation:" 
    button.target = @circle_view 
    button.bezelStyle = NSRoundedBezelStyle 
    button.autoresizingMask = NSViewMinXMargin 
    @mainWindow.contentView.addSubview(button)

    text = NSTextField.alloc.initWithFrame(NSMakeRect(24, 15, 358, 22))
    text.stringValue = "Here's to the crazy ones, the misfits, the rebels, the troublemakers, the round pegs in the square holes, the ones who see things differently."
    text.action = :"takeStringFrom:"
    text.target = @circle_view
    text.autoresizingMask = NSViewWidthSizable
    @mainWindow.contentView.addSubview(text)

    @mainWindow.orderFrontRegardless
  end
end
