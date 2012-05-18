class MustacheViewController < UIViewController
  def loadView
    self.view = UIImageView.alloc.init
    @debug_face = false # Set to true to debug face features.
  end

  def viewDidLoad
    @images = %w{matz guido kay jmccolor}.map { |name| UIImage.imageNamed(name + '.jpg') }
    view.image = @images.first
    view.contentMode = UIViewContentModeScaleAspectFit
    view.userInteractionEnabled = true

    previousGesture = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'swipe_previous_gesture:')
    previousGesture.direction = UISwipeGestureRecognizerDirectionLeft
    view.addGestureRecognizer(previousGesture)
    nextGesture = UISwipeGestureRecognizer.alloc.initWithTarget(self, action:'swipe_next_gesture:')
    nextGesture.direction = UISwipeGestureRecognizerDirectionRight
    view.addGestureRecognizer(nextGesture)
  end

  def viewDidAppear(animated)
    mustachify
  end

  def mustachify
    # Remove previous mustaches.
    view.subviews.each { |v| v.removeFromSuperview }

    # CoreImage used a coordinate system which is flipped on the Y axis
    # compared to UIKit. Also, a UIImageView can return an image larger than
    # itself. To properly translate points, we use an affine transform.
    transform = CGAffineTransformMakeScale(view.bounds.size.width / view.image.size.width, -1 * (view.bounds.size.height / view.image.size.height))
    transform = CGAffineTransformTranslate(transform, 0, -view.image.size.height)

    image = CIImage.imageWithCGImage(view.image.CGImage)
    @detector ||= CIDetector.detectorOfType CIDetectorTypeFace, context:nil, options: { CIDetectorAccuracy: CIDetectorAccuracyHigh }
    @detector.featuresInImage(image).each do |feature|
      # We need the mouth and eyes positions to determine where the mustache
      # should be added.
      next unless feature.hasMouthPosition and feature.hasLeftEyePosition and feature.hasRightEyePosition

      if @debug_face
        [feature.leftEyePosition,feature.rightEyePosition,feature.mouthPosition].each do |pt|
          v = UIView.alloc.initWithFrame CGRectMake(0, 0, 20, 20)
          v.backgroundColor = UIColor.greenColor.colorWithAlphaComponent(0.2)
          pt = CGPointApplyAffineTransform(pt, transform)
          v.center = pt
          view.addSubview(v)
        end
      end

      # Create the mustache view.
      mustacheView = UIImageView.alloc.init
      mustacheView.image = UIImage.imageNamed('mustache')
      mustacheView.contentMode = UIViewContentModeScaleAspectFit

      # Compute its location and size, based on the position of the eyes and
      # mouth. 
      w = feature.bounds.size.width
      h = feature.bounds.size.height / 5
      x = (feature.mouthPosition.x + (feature.leftEyePosition.x + feature.rightEyePosition.x) / 2) / 2 - w / 2
      y = feature.mouthPosition.y
      mustacheView.frame = CGRectApplyAffineTransform([[x, y], [w, h]], transform)

      # Apply a rotation on the mustache, based on the face inclination.
      mustacheAngle = Math.atan2(feature.leftEyePosition.x - feature.rightEyePosition.x, feature.leftEyePosition.y - feature.rightEyePosition.y) + Math::PI/2
      mustacheView.transform = CGAffineTransformMakeRotation(mustacheAngle) 

      view.addSubview(mustacheView)
    end
  end

  def shouldAutorotateToInterfaceOrientation(*)
    mustachify
    true
  end

  def swipe_previous_gesture(gesture)
    idx = @images.index(view.image)
    view.image =
      if idx == 0
        @images.last
      else
        @images[idx - 1]
      end
    mustachify
  end

  def swipe_next_gesture(gesture)
    idx = @images.index(view.image)
    view.image =
      if idx == @images.size - 1
        @images.first
      else
        @images[idx + 1]
      end
    mustachify
  end
end
