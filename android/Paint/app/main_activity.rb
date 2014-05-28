class PaintView < Android::View::View
  def onDraw(canvas)
    @paths.each { |path, paint| canvas.drawPath(path, paint) } if @paths
  end

  def onTouchEvent(event)
    x, y = event.getX, event.getY
    @paths ||= []
    case event.action
      when Android::View::MotionEvent::ACTION_DOWN
        path = Android::Graphics::Path.new
        path.moveTo(x, y)
        paint = Android::Graphics::Paint.new
        paint.color = Android::Graphics::Color.rgb(rand(255), rand(255), rand(255))
        paint.strokeWidth = 10.0
        paint.style = Android::Graphics::Paint::Style::STROKE
        paint.antiAlias = true
        @paths << [path, paint]
        true
      when Android::View::MotionEvent::ACTION_MOVE
        @paths.last[0].lineTo(x, y)
        invalidate
        true
      else
        false
    end
  end

  def clearPaths
    @paths = nil
    invalidate
  end
end

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
