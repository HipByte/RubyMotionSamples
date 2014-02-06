module Escape

  SCREEN_FRAME = CGRect.new([0, 0], [380, 678])

  unless defined?(SKColor)
    SKColor = if defined?(UIColor)
      UIColor
    elsif defined?(NSColor)
      NSColor
    end
  end

  GAME_SCREEN_COLOR = SKColor.colorWithRed(0.15, green:0.15, blue:0.3, alpha:1.0)
  # SKColor.colorWithRed(0.345, green:0.329, blue:0.314, alpha:1.0)

  LEFT_RIGHT_WALL_WIDTH  = 10
  TOP_BOTTOM_WALL_HEIGHT = 10

  module Wall
    LEFT  = 'leftWall'
    RIGHT = 'rightWall'
    TOP   = 'topWall'
    BOTTOM = 'bottomWall'
  end

  module Category
    WALL       = 1
    MONSTER    = 2
    PLAYER     = 4
    PROJECTILE = 8
  end

end