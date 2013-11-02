class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [300, 150]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    @text = NSTextField.alloc.initWithFrame([[20, 90], [200, 22]])
    @text.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @mainWindow.contentView.addSubview(@text)

    button = NSButton.alloc.initWithFrame([[220, 83], [62, 32]])
    button.title = "Calc"
    button.action = :"calc:"
    button.target = self
    button.bezelStyle = NSRoundedBezelStyle
    button.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @mainWindow.contentView.addSubview(button)

    @label = NSTextField.alloc.initWithFrame([[20, 40], [260, 22]])
    @label.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @label.editable = false
    @mainWindow.contentView.addSubview(@label)
  end

  def calc(sender)
    string = @text.stringValue
    if string =~ /^[\d\s\.\+\-\*\/]*$/
      result = eval(string)
    else
      result = "ERROR"
    end
    @label.stringValue = result.to_s
  end
end
