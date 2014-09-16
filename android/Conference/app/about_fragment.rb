class AboutFragment < Android::App::Fragment
  def onCreateView(inflater, container, savedInstanceState)
    @view ||= begin
      layout = Android::Widget::LinearLayout.new(activity)
      layout.orientation = Android::Widget::LinearLayout::VERTICAL
      pad = 30 * activity.density
      layout.setPadding(pad, pad, pad, pad)
      layout.backgroundColor = Android::Graphics::Color::WHITE

      logoView = Android::Widget::ImageView.new(activity)
      logoView.imageResource = activity.resources.getIdentifier('rmc_logo', 'drawable', activity.packageName)
      logoView.adjustViewBounds = true
      logoView.maxHeight = 400 * activity.density
      layout.addView(logoView)
 
      titleTextView = Android::Widget::TextView.new(activity)
      titleTextView.text = "#inspect 2014"
      titleTextView.textSize = 24.0
      titleTextView.setTypeface(nil, Android::Graphics::Typeface::BOLD)
      titleTextView.textColor = Android::Graphics::Color::BLACK
      titleTextView.gravity = Android::View::Gravity::CENTER_HORIZONTAL
      titleTextView.setPadding(0, 20 * activity.density, 0, 5 * activity.density)
      layout.addView(titleTextView)

      texts = [
        "A RubyMotion Conference\nwww.rubymotion.com",
        "Organized by HipByte and InfiniteRed\ninfo@hipbyte.com",
        "With the help of\nMark Lainez, Colin Gray, Rich Kilmer, Norberto Ortigoza, & Others",
        "Copyright (C) HipByte SPRL 2013-2014"
      ]
      texts.each do |text|
        textView = Android::Widget::TextView.new(activity)
        textView.text = text
        textView.textSize = 20.0
        textView.textColor = Android::Graphics::Color::BLACK
        textView.gravity = Android::View::Gravity::CENTER_HORIZONTAL
        textView.setPadding(0, 15 * activity.density, 0, 0)
        layout.addView(textView)
      end

      scrollView = Android::Widget::ScrollView.new(activity)
      scrollView.addView(layout)
      scrollView
    end
  end
end
