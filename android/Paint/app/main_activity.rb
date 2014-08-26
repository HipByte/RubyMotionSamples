class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    layout = Android::Widget::LinearLayout.new(self)
    layout.orientation = Android::Widget::LinearLayout::VERTICAL

    @paintView = PaintView.new(self)
    layout.addView(@paintView, Android::Widget::LinearLayout::LayoutParams.new(Android::View::ViewGroup::LayoutParams::MATCH_PARENT, 0.0, 1.0))

    button = Android::Widget::Button.new(self)
    button.text = 'Clear'
    button.onClickListener = self
    layout.addView(button) 

    self.contentView = layout
  end

  def onClick(view)
    @paintView.clearPaths
  end
end
