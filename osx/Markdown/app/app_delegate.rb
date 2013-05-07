class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    loadMarkdown
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    @web_view = WebView.alloc.initWithFrame(NSMakeRect(0, 0, 480, 360))
    @web_view.setAutoresizingMask(NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin|NSViewWidthSizable|NSViewHeightSizable)
    @mainWindow.contentView.addSubview(@web_view)
  end

  def loadMarkdown
    path = "#{NSBundle.mainBundle.resourcePath}/Markdown.md"
    html = convertMarkDownToHtml(path)
    @web_view.mainFrame.loadHTMLString(html, baseURL:nil)
  end

  def convertMarkDownToHtml(path)
    markdown = File.read(path)
    html = GHMarkdownParser.HTMLStringFromMarkdownString(markdown)
  end
end
