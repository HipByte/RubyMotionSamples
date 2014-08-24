class WikipediaActivity < Android::App::Activity
  SelectedState = 'com.yourcompany.states.selected_state'

  def onCreate(savedInstanceState)
    super

    state = self.intent.getStringExtra(SelectedState)
    url = "https://en.wikipedia.org/wiki/#{state}"
    puts "Loading #{url}"

    webview = Android::Webkit::WebView.new(self)
    webview.webViewClient = Android::Webkit::WebViewClient.new
    webview.loadUrl url
    self.contentView = webview
  end
end
