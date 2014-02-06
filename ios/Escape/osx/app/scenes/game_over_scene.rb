module Escape # GameOverScene
  class GameOverScene < CommonScene

    def mouseUp(event)
      touchesBegan(nil, withEvent:event)
    end

  end
end
