module Escape
  class StartScene < CommonScene

    def mouseUp(event)
      touchesBegan(nil, withEvent:event)
    end

  end
end
