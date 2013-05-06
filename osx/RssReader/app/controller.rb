class RssReaderController

  def initialize
    @data = []

    @text_url = NSTextField.alloc.initWithFrame(NSMakeRect(11, 330, 400, 22))
    @text_url.setStringValue("http://images.apple.com/main/rss/hotnews/hotnews.rss")
    @text_url.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable)
    app.window.contentView.addSubview(@text_url)

    button = NSButton.alloc.initWithFrame(NSMakeRect(415, 324, 61, 32))
    button.setTitle("Get")
    button.setAction("retrieveRSSFeed:")
    button.setTarget(self)
    button.setBezelStyle(NSRoundedBezelStyle)
    button.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin)
    app.window.contentView.addSubview(button)

    scroll_view = NSScrollView.alloc.initWithFrame(NSMakeRect(0, 0, 480, 322))
    scroll_view.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable|NSViewHeightSizable)
    scroll_view.setHasVerticalScroller(true)
    app.window.contentView.addSubview(scroll_view)

    @table_view = NSTableView.alloc.init
    column_title = NSTableColumn.alloc.initWithIdentifier("title")
    column_title.editable = false
    column_title.headerCell.setTitle("Title")
    column_title.setWidth(400)
    @table_view.addTableColumn(column_title)

    column_date = NSTableColumn.alloc.initWithIdentifier("date")
    column_date.editable = false
    column_date.headerCell.setTitle("Date")
    column_date.setWidth(400)
    @table_view.addTableColumn(column_date)

    @table_view.delegate = self
    @table_view.dataSource = self
    @table_view.setAutoresizingMask(NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin)
    @table_view.setDoubleAction("doubleClickColumn:")
    @table_view.setTarget(self)

    scroll_view.setDocumentView(@table_view)
  end

  def app
    NSApp.delegate
  end

  def loadRSS(url)
    @data = []
    parser = RSSParser.alloc.initWithDelegate(self, URL:url)
    parser.parse
  end

  def retrieveRSSFeed(sender)
    loadRSS(@text_url.stringValue)
  end

  def doubleClickColumn(sender)
    return if @data.empty?
    row = @table_view.clickedRow
    if url = @data[row]['link']
      NSWorkspace.sharedWorkspace.openURL(NSURL.URLWithString(url))
    end
  end

  def parserDidEndItem(item)
    @data << item
  end

  def parserDidEndDocument
    @table_view.reloadData
  end

  def numberOfRowsInTableView(aTableView)
    @data.size
  end

  def tableView(aTableView,
                objectValueForTableColumn: aTableColumn,
                row: rowIndex)
    case aTableColumn.identifier
    when "title"
      @data[rowIndex]['title']
    when "date"
      ['dc:date', 'pubDate', 'updated'].each do |d|
        if item = @data[rowIndex][d]
          return item
        end
      end
    end
  end

end
