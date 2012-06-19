class PlacardView < UIView

  def init
  	# Retrieve the image for the view and determine its size
  	image = UIImage.imageNamed('Placard.png')
  	frame = CGRectMake(0, 0, image.size.width, image.size.height)

  	# Set self's frame to encompass the image
  	if initWithFrame(frame)
  		self.opaque = false
  		@placard_image = image

  		# Load the display strings
      path = NSBundle.mainBundle.pathForResource('DisplayStrings', ofType: 'txt')
      string = NSString.stringWithContentsOfFile(path,
                                                 encoding: NSUTF16StringEncoding, # originally NSUTF16BigEndianStringEncoding, which fails
                                                 error: nil)
      @displayStrings = string.split("\n")
      @displayStringsIndex = 0
      setupNextDisplayString
  	end
  	self
  end

  def drawRect(rect)
  	# Draw the placard at 0, 0
  	@placard_image.drawAtPoint(CGPointMake(0, 0))
  	
    # Draw the current display string.
    # Typically you would use a UILabel, but this example serves to illustrate the UIKit extensions
    # to NSString. The text is drawn center of the view twice - first slightly offset in black,
    # then in white -- to give an embossed appearance.
    # The size of the font and text are calculated in setupNextDisplayString.

  	# Find point at which to draw the string so it will be in the center of the view
  	x = bounds.size.width / 2 - @textSize.width / 2
  	y = bounds.size.height / 2 - @textSize.height / 2

  	# Get the font of the appropriate size
  	font = UIFont.systemFontOfSize(@fontSize)

  	UIColor.blackColor.set
  	point = CGPointMake(x, y + 0.5)
  	@currentDisplayString.drawAtPoint(point,
  	                                  forWidth: bounds.size.width - STRING_INDENT,
  	                                  withFont: font,
  	                                  fontSize: @fontSize,
  	                                  lineBreakMode: UILineBreakModeMiddleTruncation,
  	                                  baselineAdjustment: UIBaselineAdjustmentAlignBaselines)

  	UIColor.whiteColor.set
  	point = CGPointMake(x, y)
  	@currentDisplayString.drawAtPoint(point,
  	                                  forWidth: bounds.size.width - STRING_INDENT,
  	                                  withFont: font,
  	                                  fontSize: @fontSize,
  	                                  lineBreakMode: UILineBreakModeMiddleTruncation,
  	                                  baselineAdjustment: UIBaselineAdjustmentAlignBaselines)
	end
	
  def setupNextDisplayString
  	# Get the string at the current index, then increment the index
  	@currentDisplayString = @displayStrings[@displayStringsIndex]
  	@displayStringsIndex += 1
  	@displayStringsIndex = 0 if @displayStringsIndex >= @displayStrings.length

  	# Precalculate size of text and size of font so that text fits inside placard
  	fontSizePtr = Pointer.new(:float)
  	@textSize = @currentDisplayString.sizeWithFont(UIFont.systemFontOfSize(24),
  	                                               minFontSize: 9.0,
  	                                               actualFontSize: fontSizePtr,
  	                                               forWidth: bounds.size.width - STRING_INDENT,
  	                                               lineBreakMode: UILineBreakModeMiddleTruncation)
    @fontSize = fontSizePtr[0]
  	setNeedsDisplay
  end
  
  private
	
	STRING_INDENT = 20

end
