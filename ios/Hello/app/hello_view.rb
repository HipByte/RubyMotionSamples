class HelloView < UIView
  def drawRect(rect)
    if @moved
      bgcolor = begin
        red, green, blue = rand(100), rand(100), rand(100)
        UIColor.colorWithRed(red/100.0, green:green/100.0, blue:blue/100.0, alpha:1.0)
      end
      text = "ZOMG!"
    else
      bgcolor = UIColor.blackColor
      text = @touches ? "Touched #{@touches} times!" : "Hello RubyMotion!"
    end

    bgcolor.set 
    UIBezierPath.bezierPathWithRect(frame).fill
  
    font = UIFont.systemFontOfSize(24)
    UIColor.whiteColor.set
    text.drawAtPoint(CGPoint.new(10, 20), withFont:font)
  end

  def touchesMoved(touches, withEvent:event)
    @moved = true
    setNeedsDisplay  
  end

  def touchesEnded(touches, withEvent:event)
    @moved = false
    @touches ||= 0
    @touches += 1
    setNeedsDisplay  
  end
end
