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
