class UIImage
  def imageRotatedByRadians(radians)
    # Calculate the size of the rotated view's containing box for our drawing space.
    rotatedViewBox = UIView.alloc.initWithFrame(CGRectMake(0,0,self.size.width, self.size.height))
    t = CGAffineTransformMakeRotation(radians)
    rotatedViewBox.transform = t
    rotatedSize = rotatedViewBox.frame.size

    # Create the bitmap context.
    UIGraphicsBeginImageContext(rotatedSize)
    bitmap = UIGraphicsGetCurrentContext()

    # Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2)

    # Rotate the image context.
    CGContextRotateCTM(bitmap, radians)

    # Now, draw the rotated/scaled image into the context.
    CGContextScaleCTM(bitmap, 1.0, -1.0)
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), self.CGImage)

    newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    newImage
  end
end
