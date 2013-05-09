class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def runAgain(sender)
    select(self)
  end

  def select(sender)
    @demo_view.demoNumber = @popup.indexOfSelectedItem
    @demo_view.needsDisplay = true
  end

  def printDocument(sender)
    info = NSPrintInfo.sharedPrintInfo
    printOp = NSPrintOperation.printOperationWithView(@demo_view, printInfo:info)
    printOp.showPanels = true
    printOp.runOperation
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [534, 474]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']

    label = NSTextField.alloc.initWithFrame([[17, 437], [139, 17]])
    label.stringValue = "Choose a path demo:"
    label.bordered = false
    label.editable = false
    label.drawsBackground = false
    label.autoresizingMask = NSViewMinYMargin
    @mainWindow.contentView.addSubview(label)

    @popup = NSPopUpButton.alloc.initWithFrame([[158, 431], [178, 24]])
    ['Rectangles', 'Circles', 'Bezier Paths', 'Circle Clipping'].each do |title|
      @popup.addItemWithTitle(title)
    end
    @popup.autoresizingMask = NSViewMinYMargin
    @popup.target = self
    @popup.action = :"runAgain:"
    @mainWindow.contentView.addSubview(@popup)

    box = NSBox.alloc.initWithFrame([[20, 20], [494, 397]])
    box.title = ""
    box.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    @mainWindow.contentView.addSubview(box)

    @demo_view = DemoView.alloc.initWithFrame([[14, 54], [462, 325]])
    @demo_view.autoresizingMask = NSViewWidthSizable|NSViewHeightSizable
    box.contentView.addSubview(@demo_view)

    button = NSButton.alloc.initWithFrame([[8, 6], [107, 32]])
    button.title = "Run Again"
    button.target = self
    button.action = :"runAgain:"
    button.bezelStyle = NSRoundedBezelStyle
    button.autoresizingMask = NSViewMaxYMargin
    box.contentView.addSubview(button)

    @mainWindow.orderFrontRegardless
  end
end
