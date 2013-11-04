class HomeScreen < ProMotion::Screen
  title 'MathJax in iOS'
  def on_load
    @web_view = add_element UIWebView.alloc.initWithFrame(self.view.bounds)
    @web_view.delegate = self
    @web_view.scrollView.scrollEnabled = false
    @web_view.scrollView.bounces = false
    @web_view.loadRequest(NSURLRequest.requestWithURL(NSURL.fileURLWithPath(NSBundle.mainBundle.pathForResource('index', ofType: 'html', inDirectory: 'html'))))
  end

  def webView(inWeb, shouldStartLoadWithRequest: inRequest, navigationType: inType)
    true
  end
end
