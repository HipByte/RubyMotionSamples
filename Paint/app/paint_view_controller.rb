class PaintViewController < UIViewController
  def loadView
    self.view = PaintView.alloc.init
  end

  def canBecomeFirstResponder
    true
  end

  def motionEnded(motion, withEvent:event)
    self.view.eraseContent if motion == UIEventSubtypeMotionShake
  end
end
