class ImageCompositionController < UIViewController
  def loadView
    self.view = UIImageView.alloc.init
    view.contentMode = UIViewContentModeScaleAspectFill
    view.userInteractionEnabled = true
    
    view.image = UIImage.imageNamed("ballmer.jpg")
    view.addSubview(troll_image_view)
    
    rotationGesture = UIRotationGestureRecognizer.alloc.initWithTarget(self, action: 'rotate_image:')
    troll_image_view.addGestureRecognizer(rotationGesture)
    
    panGesture = UIPanGestureRecognizer.alloc.initWithTarget(self, action: 'pan_image:')
    panGesture.maximumNumberOfTouches = 2
    panGesture.delegate = self
    troll_image_view.addGestureRecognizer(panGesture)
    
    pinchGesture = UIPinchGestureRecognizer.alloc.initWithTarget(self, action:'scale_image:')
    pinchGesture.delegate = self
    troll_image_view.addGestureRecognizer(pinchGesture)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Pick", style:UIBarButtonItemStylePlain, target:self, action:'show_source_sheet')
    navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Save", style:UIBarButtonItemStylePlain, target:self, action:'save_image')
  end

  def viewWillAppear(animated)
    navigationController.setNavigationBarHidden(false, animated:true)
    troll_image_view.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
  end

  def troll_image_view
    @troll_image_view ||= begin
      image = UIImageView.alloc.init
      image.image = UIImage.imageNamed("trollface.png")
      image.frame = CGRectMake(0, 0, image.image.size.width, image.image.size.height)
      image.userInteractionEnabled = true
  
      # Set initial scale of the trollface to a quarter.
      image.transform = CGAffineTransformMakeScale(0.25, 0.25)
      image
    end
  end
  
  # Scale and rotation transforms are applied relative to the layer's anchor point.
  # This method moves a gesture recognizer's view's anchor point between the user's fingers.
  def adjust_anchor_point_for_gesture_recognizer(gestureRecognizer)
    if gestureRecognizer.state == UIGestureRecognizerStateBegan
      locationInView = gestureRecognizer.locationInView(troll_image_view)
      locationInSuperview = gestureRecognizer.locationInView(troll_image_view.superview)

      troll_image_view.layer.anchorPoint = CGPointMake(locationInView.x / troll_image_view.bounds.size.width, locationInView.y / troll_image_view.bounds.size.height)
      troll_image_view.center = locationInSuperview
    end
  end
  
  def rotate_image(gestureRecognizer)
    adjust_anchor_point_for_gesture_recognizer(gestureRecognizer)
    if gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged
      gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation)
      gestureRecognizer.rotation = 0
    end
  end
  
  def pan_image(gestureRecognizer)
    adjust_anchor_point_for_gesture_recognizer(gestureRecognizer)
    if gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged
      translation = gestureRecognizer.translationInView(troll_image_view.superview)
      troll_image_view.center = CGPointMake(troll_image_view.center.x + translation.x, troll_image_view.center.y + translation.y)
      gestureRecognizer.setTranslation(CGPointZero, inView:troll_image_view.superview)
    end
  end
  
  def scale_image(gestureRecognizer)
    adjust_anchor_point_for_gesture_recognizer(gestureRecognizer)
    if gestureRecognizer.state == UIGestureRecognizerStateBegan || gestureRecognizer.state == UIGestureRecognizerStateChanged
      gestureRecognizer.view.transform = CGAffineTransformScale(gestureRecognizer.view.transform, gestureRecognizer.scale, gestureRecognizer.scale)
      gestureRecognizer.scale = 1
    end
  end
  
  def gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer)
    true
  end
  
  def show_source_sheet
    popupQuery = UIActionSheet.alloc.initWithTitle("", delegate:self, cancelButtonTitle:'Cancel', destructiveButtonTitle:nil, otherButtonTitles:"Choose Existing", "Take Picture", nil)
    popupQuery.delegate = self
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque
    popupQuery.showInView(view)
  end
  
  def actionSheet(actionSheet, clickedButtonAtIndex:buttonIndex)
    case buttonIndex
      when 0
        pick_image
      when 1
        take_image
      when 2
        # cancelled
    end
  end
  
  def pick_image
    pick_image_with_source(UIImagePickerControllerSourceTypePhotoLibrary)
  end
  
  def take_image
    pick_image_with_source(UIImagePickerControllerSourceTypeCamera)
  end
  
  def pick_image_with_source(source_type)
    # Create and show the image picker.
    imagePicker = UIImagePickerController.alloc.init
    imagePicker.sourceType =  source_type
    imagePicker.mediaTypes = [KUTTypeImage]
    imagePicker.delegate = self
    imagePicker.allowsImageEditing = false
    presentModalViewController(imagePicker, animated:true)
  end
  
  # UIImagePickerControllerDelegate methods

  def imagePickerControllerDidCancel(picker)
    dismissModalViewControllerAnimated(true)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info) 
    mediaType = info[UIImagePickerControllerMediaType]
    if mediaType == KUTTypeImage
      editedImage = info[UIImagePickerControllerEditedImage]
      originalImage = info[UIImagePickerControllerOriginalImage]
      view.image = editedImage || originalImage
    end
    dismissModalViewControllerAnimated(true)
  end
  
  def save_image
    image = view.image

    troll_image_transform = troll_image_view.transform
    trollfaceRotation = Math.atan2(troll_image_transform.b, troll_image_transform.a)
    trollfaceScaleX = Math.sqrt(troll_image_transform.a**2 + troll_image_transform.c**2)
    trollfaceScaleY = Math.sqrt(troll_image_transform.b**2  + troll_image_transform.d**2)

     # We are displaying the image in AspectFill mode. This will give us the scale.
    scale = [image.size.width/view.frame.size.width, image.size.height/view.frame.size.height].min

    targetWidth = image.size.width
    targetHeight = image.size.height

    # Image Rect and Image Context in the size of the image.
    imageRect = CGRectMake(0, 0, image.size.width, image.size.height)

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(targetWidth, targetHeight), true, UIScreen.mainScreen.scale)
    c = UIGraphicsGetCurrentContext()
    image.drawInRect(imageRect)

    # Potential landscape rotation.
    CGContextSaveGState(c)
     
    # Get the (possibly rotated) image.
    trollface_image = troll_image_view.image 
    if trollfaceRotation != 0
      trollface_image = troll_image_view.image.imageRotatedByRadians(trollfaceRotation)
    end

    # Move the context down and left (or either or) to match where the trollface view was on the screen
    CGContextTranslateCTM(c, (image.size.width-view.frame.size.width*scale)/2, (image.size.height-view.frame.size.height*scale)/2)
    # Scale the coordinate context,
    CGContextScaleCTM(c, scale, scale)

    # Draw the trollface image, correctly scaled.
    trollface_image.drawInRect(CGRectMake(troll_image_view.frame.origin.x, troll_image_view.frame.origin.y, trollface_image.size.width * trollfaceScaleX, trollface_image.size.height * trollfaceScaleY))

    CGContextRestoreGState(c) 

    newImage = UIGraphicsGetImageFromCurrentImageContext()  # UIImage returned

    UIGraphicsEndImageContext()
          
    # Save to camera roll.
    library = ALAssetsLibrary.alloc.init
    library.writeImageToSavedPhotosAlbum(newImage.CGImage, orientation:ALAssetOrientationUp, completionBlock: lambda do |assetURL, error|
      if error
        alert = UIAlertView.alloc.init
        alert.title = "Error When Saving Picture"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle('OK')
        alert.show
      end
    end)     
  end
end
