module Escape # GameScreen
  class MainGameScene < CommonScene

    def acceptsFirstMouse(event)
      true
    end

    def didMoveToView(view)
      # without this, dragging the player wouldn't work
      NSApp.delegate.window.makeFirstResponder(self)
      super
    end

    def mouseDragged(event)
      dragPlayer(event)
    end

    def dragPlayer(event)
        newLocation = self.convertPointToView(event.locationInWindow)
        self.player.position = checkBounds(newLocation)        
      end
  end
end