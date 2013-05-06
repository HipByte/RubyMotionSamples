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
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    @text_search = NSTextField.alloc.initWithFrame(NSMakeRect(20, 318, 341, 22))
    @text_search.setStringValue("xcode crash")
    @text_search.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable)
    @mainWindow.contentView.addSubview(@text_search)

    button = NSButton.alloc.initWithFrame(NSMakeRect(384, 310, 82, 32))
    button.setTitle("Search")
    button.setAction("search:")
    button.setTarget(self)
    button.setBezelStyle(NSRoundedBezelStyle)
    button.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin)
    @mainWindow.contentView.addSubview(button)

    scroll_view = NSScrollView.alloc.initWithFrame(NSMakeRect(0, 0, 480, 300))
    scroll_view.setAutoresizingMask(NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable|NSViewHeightSizable)
    scroll_view.setHasVerticalScroller(true)
    @mainWindow.contentView.addSubview(scroll_view)

    @table_view = NSTableView.alloc.init
    column_avator = NSTableColumn.alloc.initWithIdentifier("avator")
    column_avator.editable = false
    column_avator.headerCell.setTitle("Avator")
    column_avator.setWidth(40)
    column_avator.setDataCell(NSImageCell.alloc.init)
    @table_view.addTableColumn(column_avator)

    column_name = NSTableColumn.alloc.initWithIdentifier("name")
    column_name.editable = false
    column_name.headerCell.setTitle("Name")
    column_name.setWidth(150)
    @table_view.addTableColumn(column_name)

    column_tweet = NSTableColumn.alloc.initWithIdentifier("tweet")
    column_tweet.editable = false
    column_tweet.headerCell.setTitle("Tweet")
    column_tweet.setWidth(290)
    @table_view.addTableColumn(column_tweet)

    @table_view.delegate = self
    @table_view.dataSource = self
    @table_view.setAutoresizingMask(NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin)

    scroll_view.setDocumentView(@table_view)

  end

  def search(sender)
    text = @text_search.stringValue
    if text.length > 0
      query = text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
      url = "http://search.twitter.com/search.json?q=#{query}"

      Dispatch::Queue.concurrent.async do
        json = nil
        begin
          json = JSONParser.parse_from_url(url)
        rescue RuntimeError => e
          presentError e.message
        end

        @search_result = []
        json['results'].each do |dict|
          tweet = Tweet.new(dict)
          @search_result << tweet

          Dispatch::Queue.concurrent.async do
            profile_image_data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(tweet.profile_image_url))
            if profile_image_data
              tweet.profile_image = NSImage.alloc.initWithData(profile_image_data)
              Dispatch::Queue.main.sync do
                @table_view.reloadData
              end
            end
          end
        end

        Dispatch::Queue.main.sync { @table_view.reloadData }
      end

    end
  end

  def numberOfRowsInTableView(aTableView)
    return 0 if @search_result.nil?
    return @search_result.size
  end

  def tableView(aTableView,
                objectValueForTableColumn: aTableColumn,
                row: rowIndex)
    case aTableColumn.identifier
    when "avator"
      return @search_result[rowIndex].profile_image
    when "name"
      return @search_result[rowIndex].author
    when "tweet"
      return @search_result[rowIndex].message
    end
  end

end
