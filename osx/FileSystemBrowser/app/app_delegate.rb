class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = 'File System Browser'

    # Build the scroll view that will embed our outline view.
    scrollView = NSScrollView.alloc.initWithFrame(@mainWindow.contentView.bounds)
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    scrollView.hasVerticalScroller = true
    @mainWindow.contentView.addSubview(scrollView)

    # Build the outline view.
    outlineView = NSOutlineView.alloc.initWithFrame(scrollView.bounds)
    outlineView.dataSource = outlineView.delegate = self
    outlineView.addTableColumn(NSTableColumn.alloc.initWithIdentifier('Path').tap { |col|
      col.minWidth = 360
    })
    outlineView.outlineTableColumn = outlineView.tableColumns[0]
    outlineView.headerView = nil # hide columns headers

    # Add the outline view into the scroll view.
    scrollView.documentView = outlineView

    @mainWindow.orderFrontRegardless
  end

  # NSOutlineViewDelegate protocol.

  def outlineView(outlineView, numberOfChildrenOfItem:item)
    item ? item.numberOfChildren : 1
  end
  
  def outlineView(outlineView, isItemExpandable:item)
    item ? item.numberOfChildren != -1 : true
  end
  
  def outlineView(outlineView, child:index, ofItem:item)
    item ? item.childAtIndex(index) : FileSystemItem.rootItem
  end
  
  def outlineView(outlineView, objectValueForTableColumn:tableColumn, byItem:item)
    if item
      s = item.relativePath
    else
      '/'
    end
  end
  
  def outlineView(outlineView, shouldEditTableColumn:tableColumn, item:item)
    false
  end
end
