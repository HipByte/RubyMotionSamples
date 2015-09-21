class PaintView < UIView
  def initWithFrame(rect)
    if super
      path = NSBundle.mainBundle.pathForResource('erase', ofType:'caf')
      url = NSURL.fileURLWithPath(path)
      error_ptr = Pointer.new(:id)
      @eraseSound = AVAudioPlayer.alloc.initWithContentsOfURL(url,
        error:error_ptr)
      unless @eraseSound
        raise "Can't open sound file: #{error_ptr[0].description}"
      end
      @paths = []
    end
    self
  end

  def drawRect(rect)
    UIColor.blackColor.set
    UIBezierPath.bezierPathWithRect(rect).fill
    @paths.each do |path, color|
      color.set
      path.stroke
    end
  end

  def touchesBegan(touches, withEvent:event)
    bp = UIBezierPath.alloc.init
    bp.lineWidth = 3.0
    random_color = begin
      red, green, blue = rand(100)/100.0, rand(100)/100.0, rand(100)/100.0
      UIColor.alloc.initWithRed(red, green:green, blue:blue, alpha:1.0)
    end
    @paths << [bp, random_color]
  end

  def touchesMoved(touches, withEvent:event)
    touch = event.touchesForView(self).anyObject
    point = touch.locationInView(self)
    if @previousPoint and !@paths.empty?
      bp = @paths.last.first
      bp.moveToPoint(@previousPoint)
      bp.addLineToPoint(point)
    end
    @previousPoint = point
    setNeedsDisplay
  end

  def touchesEnded(touches, withEvent:event)
    @previousPoint = nil
  end

  def eraseContent
    @paths.clear
    @eraseSound.play
    setNeedsDisplay
  end
end
