class SlideshowView < NSView
  def initWithFrame(frame)
    super

    # preload shading bitmap to use in transitions:

    # this one is for "SlideshowViewPageCurlTransitionStyle", and "SlideshowViewRippleTransitionStyle"
    bundle = NSBundle.bundleForClass(self.class)
    pathURL = NSURL.fileURLWithPath(bundle.pathForResource("restrictedshine", ofType:"tiff"))
    @inputShadingImage = CIImage.imageWithContentsOfURL(pathURL)

    # this one is for "SlideshowViewDisintegrateWithMaskTransitionStyle"
    pathURL = NSURL.fileURLWithPath(bundle.pathForResource("transitionmask", ofType:"jpg"))
    @inputMaskImage = CIImage.imageWithContentsOfURL(pathURL)

    self
  end

  def updateSubviewsWithTransition(transition)
    rect = self.bounds

    # Use Core Animation's four built-in CATransition types,
    # or an appropriately instantiated and configured Core Image CIFilter.

    if transitionFilter = CIFilter.filterWithName(transition)
      transitionFilter.setDefaults
    end

    case transition
    when "CICopyMachineTransition"
      transitionFilter.setValue(
          CIVector.vectorWithX(rect.origin.x, Y:rect.origin.y, Z:rect.size.width, W:rect.size.height),
          forKey:"inputExtent")
    when "CIDisintegrateWithMaskTransition"
      # scale our mask image to match the transition area size, and set the scaled result as the
      # "inputMaskImage" to the transitionFilter.
      maskScalingFilter = CIFilter.filterWithName("CILanczosScaleTransform")
      maskScalingFilter.setDefaults
      maskExtent = @inputMaskImage.extent
      xScale = rect.size.width / maskExtent.size.width;
      yScale = rect.size.height / maskExtent.size.height;
      maskScalingFilter.setValue(yScale, forKey:"inputScale")
      maskScalingFilter.setValue(xScale / yScale, forKey:"inputAspectRatio")
      maskScalingFilter.setValue(@inputMaskImage, forKey:"inputImage")

      transitionFilter.setValue(maskScalingFilter.valueForKey("outputImage"), forKey:"inputMaskImage")
    when "CIFlashTransition"
      transitionFilter.setValue(CIVector.vectorWithX(NSMidX(rect), Y:NSMidY(rect)), forKey:"inputCenter")
      transitionFilter.setValue(CIVector.vectorWithX(rect.origin.x, Y:rect.origin.y, Z:rect.size.width, W:rect.size.height), forKey:"inputExtent")
    when "CIModTransition"
      transitionFilter.setValue(CIVector.vectorWithX(NSMidX(rect), Y:NSMidY(rect)), forKey:"inputCenter")
    when "CIPageCurlTransition"
      transitionFilter.setValue(-Math::PI/4, forKey:"inputAngle")
      transitionFilter.setValue(@inputShadingImage, forKey:"inputShadingImage")
      transitionFilter.setValue(@inputShadingImage, forKey:"inputBacksideImage")
      transitionFilter.setValue(CIVector.vectorWithX(rect.origin.x, Y:rect.origin.y, Z:rect.size.width, W:rect.size.height), forKey:"inputExtent")
    when "CIRippleTransition"
      transitionFilter.setValue(CIVector.vectorWithX(NSMidX(rect), Y:NSMidY(rect)), forKey:"inputCenter")
      transitionFilter.setValue(CIVector.vectorWithX(rect.origin.x, Y:rect.origin.y, Z:rect.size.width, W:rect.size.height), forKey:"inputExtent")
      transitionFilter.setValue(@inputShadingImage, forKey:"inputShadingImage")
    end

    # construct a new CATransition that describes the transition effect we want.
    newTransition = CATransition.animation
    if transitionFilter
      # we want to build a CIFilter-based CATransition.
      # When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored,
      # so we don't need to bother setting them.
        newTransition.setFilter(transitionFilter)
    else
      # we want to specify one of Core Animation's built-in transitions.
      newTransition.setType(transition)
      newTransition.setSubtype(KCATransitionFromLeft)
    end

    # specify an explicit duration for the transition.
    newTransition.setDuration(1.0)

    # associate the CATransition we've just built with the "subviews" key for this SlideshowView instance,
    # so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
    self.setAnimations(NSDictionary.dictionaryWithObject(newTransition, forKey:"subviews"))
  end

  def isOpaque
    # we're opaque, since we fill with solid black in our -drawRect: method, below.
    true
  end

  def drawRect(rect)
    # draw a solid black background by default
    NSColor.blackColor.set
    NSRectFill(rect)
  end

  def transitionToImage(newImage)
    # create a new NSImageView and swap it into the view in place of our previous NSImageView.
    # this will trigger the transition animation we've wired up in -updateSubviewsTransition,
    # which fires on changes in the "subviews" property.
    @newImageView = NSImageView.alloc.initWithFrame(self.bounds)
    @newImageView.setImage(newImage)
    @newImageView.setAutoresizingMask(NSViewWidthSizable|NSViewHeightSizable)

    if @currentImageView && @newImageView
      self.animator.replaceSubview(@currentImageView, with:@newImageView)
    else
      @currentImageView.animator.removeFromSuperview if @currentImageView
      self.animator.addSubview(@newImageView) if @newImageView
    end
    @currentImageView = @newImageView
  end
end