module Escape # CommonScene
  class CommonScene < SKScene

    def didMoveToView(view)
      unless @_contentCreated
        createSceneContents
        @_contentCreated = true
      end
    end


    # you better override this :-)
    def createSceneContents
    end

  end
end