class MoveMeView < UIView

  def initWithFrame(frame)
    if super
      # Create the placard view -- its init method calculates its frame based on its image
      @placard_view = PlacardView.alloc.init
      @placard_view.center = self.center
      self.addSubview(@placard_view)
    end
    self
  end
  
  def placardView
    @placard_view
  end

  def touchesBegan(touches, withEvent: event)
    # We only support single touches, so anyObject retrieves just that touch from touches
    touch = touches.anyObject

    # Only move the placard view if the touch was in the placard view
    if touch.view == placardView
      # Animate the first touch
      animateFirstTouchAtPoint(touch.locationInView(self))
    else
      # In case of a double tap outside the placard view, update the placard's display string
      placardView.setupNextDisplayString if touch.tapCount == 2
    end
  end

  def touchesMoved(touches, withEvent: event)
    touch = touches.anyObject

    # If the touch was in the placardView, move the placardView to its location
    if touch.view == placardView
      location = touch.locationInView(self)
      placardView.center = location
    end
  end
    
  def touchesEnded(touches, withEvent: event)
    touch = touches.anyObject

    # If the touch was in the placardView, bounce it back to the center
    if touch.view == placardView
      # Disable user interaction so subsequent touches don't interfere with animation
      self.userInteractionEnabled = false
      animatePlacardViewToCenter
    end
  end
  
  def animationDidStop(theAnimation, finished: flag)
    # Animation delegate method called when the animation's finished:
    # restore the transform and reenable user interaction
    placardView.transform = CGAffineTransformIdentity
    self.userInteractionEnabled = true
  end
  
  private
  
  GROW_ANIMATION_DURATION_SECONDS = 0.15
  MOVE_ANIMATION_DURATION_SECONDS = 0.15
  
  def animateFirstTouchAtPoint(touch_point)
    # "Pulse" the placard view by scaling up then down, then move the placard to under the finger.
    UIView.animateWithDuration(GROW_ANIMATION_DURATION_SECONDS,
      animations: -> {
        placardView.transform = CGAffineTransformMakeScale(1.2, 1.2)
      },
      completion: -> (finished) {
        UIView.animateWithDuration(MOVE_ANIMATION_DURATION_SECONDS,
          animations: -> {
            placardView.transform = CGAffineTransformMakeScale(1.1, 1.1)
            placardView.center = touch_point
          }
        )
      }
    )
  end
  
  def animatePlacardViewToCenter
    # Bounces the placard back to the center

    welcomeLayer = placardView.layer

    # Create a keyframe animation to follow a path back to the center
    bounceAnimation = CAKeyframeAnimation.animationWithKeyPath(:position)
    bounceAnimation.removedOnCompletion = false

    animationDuration = 1.5

    # Create the path for the bounces
    thePath = CGPathCreateMutable()

    midX = self.center.x
    midY = self.center.y
    originalOffsetX = placardView.center.x - midX
    originalOffsetY = placardView.center.y - midY
    offsetDivider = 4.0

    stopBouncing = false

    # Start the path at the placard's current location
    CGPathMoveToPoint(thePath, nil, placardView.center.x, placardView.center.y)
    CGPathAddLineToPoint(thePath, nil, midX, midY)

    # Add to the bounce path in decreasing excursions from the center
    while !stopBouncing
      CGPathAddLineToPoint(thePath, nil, midX + originalOffsetX / offsetDivider,
                                         midY + originalOffsetY / offsetDivider)
      CGPathAddLineToPoint(thePath, nil, midX, midY)

      offsetDivider += 4
      animationDuration += 1 / offsetDivider
      if ((originalOffsetX / offsetDivider).abs < 6) && ((originalOffsetY / offsetDivider).abs < 6)
        stopBouncing = true
      end
    end

    bounceAnimation.path = thePath
    bounceAnimation.duration = animationDuration
    
    # Create a basic animation to restore the size of the placard
    transformAnimation = CABasicAnimation.animationWithKeyPath(:transform)
    transformAnimation.removedOnCompletion = true
    transformAnimation.duration = animationDuration
    transformAnimation.toValue = NSValue.valueWithCATransform3D(CATransform3DIdentity)

    # Create an animation group to combine the keyframe and basic animations
    theGroup = CAAnimationGroup.animation

    # Set self as the delegate to allow for a callback to reenable user interaction
    theGroup.delegate = self
    theGroup.duration = animationDuration
    theGroup.timingFunction = CAMediaTimingFunction.functionWithName(KCAMediaTimingFunctionEaseIn)
    theGroup.animations = [bounceAnimation, transformAnimation]

    # Add the animation group to the layer
    welcomeLayer.addAnimation(theGroup, forKey: :animatePlacardViewToCenter)

    # Set the placard view's center and transformation to the original values in preparation for the
    # end of the animation
    placardView.center = self.center
    placardView.transform = CGAffineTransformIdentity
  end
end
