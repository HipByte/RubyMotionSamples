class UIColor
  def color_with_brightness(brightnessComponent)
    hue = Pointer.new(:float)
    saturation = Pointer.new(:float)
    brightness = Pointer.new(:float)
    red = Pointer.new(:float)
    green = Pointer.new(:float)
    blue = Pointer.new(:float)
    white = Pointer.new(:float)
    alpha = Pointer.new(:float)

    if getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
      UIColor.colorWithHue(hue[0], saturation: saturation[0], brightness: brightness[0] * brightnessComponent, alpha: alpha[0])
    elsif getRed(red, green: green, blue: blue, alpha: alpha)
      UIColor.colorWithRed(red[0] * brightnessComponent, green: green[0] * brightnessComponent, blue: blue[0] * brightnessComponent, alpha: alpha[0])
    elsif getWhite(white, alpha: alpha)
      UIColor.colorWithWhite(white[0] * brightnessComponent, alpha: alpha[0])
    end
  end

  def colorWithHueOffset(hueOffset)
    hue = Pointer.new(:float)
    saturation = Pointer.new(:float)
    brightness = Pointer.new(:float)
    alpha = Pointer.new(:float)

    if getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
      newHue = (hue[0] + hueOffset) % 1
      UIColor.colorWithHue(newHue, saturation: saturation[0], brightness: brightness[0], alpha: alpha[0])
    end
  end
end
