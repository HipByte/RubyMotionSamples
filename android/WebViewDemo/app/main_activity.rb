class MainActivity < Android::App::Activity
  attr_reader :webview, :handler

  def onCreate(savedInstanceState)
    super
    @handler = Android::Os::Handler.new

    @webview = Android::Webkit::WebView.new(self)
    settings = @webview.settings
    settings.savePassword = false
    settings.saveFormData = false
    settings.javaScriptEnabled = true
    settings.supportZoom = false

    @webview.webChromeClient = MyWebChromeClient.new
    js_interface = DemoJavaScriptInterface.new
    js_interface.context = self
    @webview.addJavascriptInterface(js_interface, "demo")

    @webview.loadUrl("file:///android_asset/demo.html")

    self.contentView = @webview
  end
end

class DemoJavaScriptInterface < Java::Lang::Object
  attr_accessor :context

  __annotation__('@android.webkit.JavascriptInterface')
  def clickOnAndroid
    # This method will be called from another thread, and WebView calls must
    # happen in the main thread, so we dispatch it via a Handler object.
    @context.handler.post -> { @context.webview.loadUrl("javascript:wave()") }
  end
end

class MyWebChromeClient < Android::Webkit::WebChromeClient
  def onJsAlert(view, url, message, result)
    puts message
    result.confirm
    true
  end
end
