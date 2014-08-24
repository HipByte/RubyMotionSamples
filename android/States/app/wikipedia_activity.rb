class WikipediaActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    intent = getIntent()

    # RubyMotion Error:
    #W/dalvikvm(29208): No implementation found for native Lcom/rubymotion/Module;.finalize:()V
    state = intent.getStringExtra("state")

    @webview = Android::Webkit::WebView.new(self)
    @webview.webViewClient = Android::Webkit::WebViewClient.new
    @webview.loadUrl "https://en.wikipedia.org/wiki/#{state}"
    self.contentView = @webview
  end
end
