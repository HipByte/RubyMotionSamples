class MainActivity < Android::App::Activity
  def onCreate(savedInstanceState)
    super

    @text = Android::Widget::TextView.new(self)
    @text.text = 'Hello RubyMotion!'
    @text.textColor = Android::Graphics::Color::WHITE
    @text.textSize = 40.0
    self.contentView = @text
  end

  def dispatchTouchEvent(event)
    @counter ||= 0
    case event.action
      when Android::View::MotionEvent::ACTION_UP
        @counter += 1
        @text.text = "Touched #{@counter} times!"
        @text.backgroundColor = Android::Graphics::Color::BLACK
      when Android::View::MotionEvent::ACTION_MOVE
        @text.text = "ZOMG!"
        @text.backgroundColor = Android::Graphics::Color.rgb(rand(255), rand(255), rand(255))
      end
    true
  end
end
