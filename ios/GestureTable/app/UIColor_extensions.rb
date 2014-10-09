class UIColor
  CGFloat_Type = CGSize.type[/(f|d)/]

  def colorWithBrightness(brightnessComponent)
    hue = Pointer.new(CGFloat_Type)
    saturation = Pointer.new(CGFloat_Type)
    brightness = Pointer.new(CGFloat_Type)
    red = Pointer.new(CGFloat_Type)
    green = Pointer.new(CGFloat_Type)
    blue = Pointer.new(CGFloat_Type)
    white = Pointer.new(CGFloat_Type)
    alpha = Pointer.new(CGFloat_Type)

    if getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
      UIColor.colorWithHue(hue[0], saturation: saturation[0], brightness: brightness[0] * brightnessComponent, alpha: alpha[0])
    elsif getRed(red, green: green, blue: blue, alpha: alpha)
      UIColor.colorWithRed(red[0] * brightnessComponent, green: green[0] * brightnessComponent, blue: blue[0] * brightnessComponent, alpha: alpha[0])
    elsif getWhite(white, alpha: alpha)
      UIColor.colorWithWhite(white[0] * brightnessComponent, alpha: alpha[0])
    end
  end

  def colorWithHueOffset(hueOffset)
    hue = Pointer.new(CGFloat_Type)
    saturation = Pointer.new(CGFloat_Type)
    brightness = Pointer.new(CGFloat_Type)
    alpha = Pointer.new(CGFloat_Type)

    if getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
      newHue = (hue[0] + hueOffset) % 1
      UIColor.colorWithHue(newHue, saturation: saturation[0], brightness: brightness[0], alpha: alpha[0])
    end
  end
end
