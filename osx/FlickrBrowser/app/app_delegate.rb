class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [640, 480]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @photoController = PhotoController.new(@mainWindow)
    @mainWindow.orderFrontRegardless

    # Create and add toolbar.
    toolbar = NSToolbar.alloc.initWithIdentifier('MyAwesomeToolbar')
    toolbar.allowsUserCustomization = true
    toolbar.displayMode = NSToolbarDisplayModeIconOnly
    toolbar.delegate = self
    @mainWindow.toolbar = toolbar

    @photoController.searchImages('cat')
  end

  # NSToolbarDelegate protocol.

  SearchPhotoIdentifier = 'SearchPhotoIdentifier'

  def toolbarAllowedItemIdentifiers(toolbar)
    [SearchPhotoIdentifier, NSToolbarFlexibleSpaceItemIdentifier, NSToolbarSpaceItemIdentifier, NSToolbarSeparatorItemIdentifier]  
  end

  def toolbarDefaultItemIdentifiers(toolbar)
    [NSToolbarFlexibleSpaceItemIdentifier, SearchPhotoIdentifier]
  end

  def toolbar(toolbar, itemForItemIdentifier:identifier, willBeInsertedIntoToolbar:flag)
    if identifier == SearchPhotoIdentifier
      item = NSToolbarItem.alloc.initWithItemIdentifier(identifier)
      item.label = 'Search Flickr'
      view = NSSearchField.alloc.initWithFrame(NSZeroRect)
      view.target = self
      view.action = :"toolbarSearch:"
      view.frame = [[0, 0], [200, 0]]
      item.view = view
      item
    end
  end

  def toolbarSearch(sender)
    @photoController.searchImages(sender.stringValue.strip)
  end
end
