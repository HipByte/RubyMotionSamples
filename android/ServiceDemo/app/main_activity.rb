class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    layout = Android::Widget::LinearLayout.new(self)
    layout.orientation = Android::Widget::LinearLayout::VERTICAL

    button = Android::Widget::Button.new(self)
    button.text = 'Start'
    button.onClickListener = self
    layout.addView(button)

    self.contentView = layout

onClick(nil)
  end

  def onClick(view)
    intent = Android::Content::Intent.new(self, MyService)
    if @started
      stopService(intent)
      @started = nil
    else
      startService(intent)
    end
  end
end
