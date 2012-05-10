class WebViewController < UIViewController
  def loadView
    background = UIColor.blackColor
    
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    self.view.backgroundColor = background
    
    webFrame = UIScreen.mainScreen.applicationFrame
    webFrame.origin.y = 0.0
    @webView = UIWebView.alloc.initWithFrame(webFrame)
    @webView.backgroundColor = background
    @webView.scalesPageToFit = true
    @webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)
    @webView.delegate = self
    @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('index', ofType:'html'))))
    # @webView.loadRequest(NSURLRequest.requestWithURL(NSURL.URLWithString("http://www.fngtps.com/")))
    # @webView.loadHTMLString('<h1><a href="http://www.fngtps.com">Click me!</h1>', baseURL:nil)
  end
  
  def wantsFullScreenLayout
    true
  end
  
  def webViewDidFinishLoad(webView)
    self.view.addSubview(@webView)
  end
  
  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    true
  end
  
  def webView(inWeb, shouldStartLoadWithRequest:inRequest, navigationType:inType)
    if inType == UIWebViewNavigationTypeLinkClicked
      UIApplication.sharedApplication.openURL(inRequest.URL)
      return false
    end
    true
  end
end