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
    @text_search.stringValue = "xcode crash"
    @text_search.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable
    @mainWindow.contentView.addSubview(@text_search)

    button = NSButton.alloc.initWithFrame(NSMakeRect(384, 310, 82, 32))
    button.title = "Search"
    button.action = :"search:"
    button.target = self
    button.bezelStyle = NSRoundedBezelStyle
    button.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin
    @mainWindow.contentView.addSubview(button)

    scroll_view = NSScrollView.alloc.initWithFrame(NSMakeRect(0, 0, 480, 300))
    scroll_view.autoresizingMask = NSViewMinXMargin|NSViewMinYMargin|NSViewWidthSizable|NSViewHeightSizable
    scroll_view.hasVerticalScroller = true
    @mainWindow.contentView.addSubview(scroll_view)

    @table_view = NSTableView.alloc.init
    column_avatar = NSTableColumn.alloc.initWithIdentifier("avatar")
    column_avatar.editable = false
    column_avatar.headerCell.title = "Avatar"
    column_avatar.width = 40
    column_avatar.dataCell = NSImageCell.alloc.init
    @table_view.addTableColumn(column_avatar)

    column_name = NSTableColumn.alloc.initWithIdentifier("name")
    column_name.editable = false
    column_name.headerCell.title ="Name"
    column_name.width = 150
    @table_view.addTableColumn(column_name)

    column_tweet = NSTableColumn.alloc.initWithIdentifier("tweet")
    column_tweet.editable = false
    column_tweet.headerCell.setTitle("Tweet")
    column_tweet.width = 290
    @table_view.addTableColumn(column_tweet)

    @table_view.delegate = self
    @table_view.dataSource = self
    @table_view.autoresizingMask = NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin

    scroll_view.documentView = @table_view

    search(self)
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
    @search_result ? @search_result.size : 0
  end

  def tableView(aTableView,
                objectValueForTableColumn: aTableColumn,
                row: rowIndex)
    case aTableColumn.identifier
      when "avatar"
        @search_result[rowIndex].profile_image
      when "name"
        @search_result[rowIndex].author
      when "tweet"
        @search_result[rowIndex].message
    end
  end
end
