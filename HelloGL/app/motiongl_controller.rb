class MotionGLController < GLKViewController
  
  def loadView
    self.view = GLKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @increasing = true
    @curRed = 0.0
    #self.view.delegate = self
  end
  
  def setupGL
    EAGLContext.setCurrentContext(@context)
    
    @effect = GLKBaseEffect.alloc.init
    
    options = {GLKTextureLoaderOriginBottomLeft => true}
    
    path = NSBundle.mainBundle.pathForResource("rubymotion", ofType:"png")
    perror = Pointer.new(:object) 
    info = GLKTextureLoader.textureWithContentsOfFile(path, options:options, error:perror)
    
    if (info == nil) 
      puts("Error loading file: %@", perror[0].localizedDescription)
    end
    @effect.texture2d0.name = info.name
    @effect.texture2d0.enabled = true
 
    @vertices = VertexData.new([
      [ 1.0, -1.0, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0],
      [ 1.0,  1.0, 0.0, 0.0, 1.0, 0.0, 1.0, 1.0, 1.0],
      [-1.0,  1.0, 0.0, 0.0, 0.0, 1.0, 1.0, 0.0, 1.0],
      [-1.0, -1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0]
    ])
    
    @indices = IndexData.new(
      [0, 1, 2,
       2, 3, 0]
    )
    
    vertexBufferPtr = Pointer.new(:uchar)
    glGenBuffers(1, vertexBufferPtr)
    @vertexBuffer = vertexBufferPtr[0]
    glBindBuffer(GL_ARRAY_BUFFER, @vertexBuffer)
    glBufferData(GL_ARRAY_BUFFER, @vertices.size*4, @vertices.ptr, GL_STATIC_DRAW)
 
    indexBufferPtr = Pointer.new(:uchar)
    glGenBuffers(1, indexBufferPtr)
    @indexBuffer = indexBufferPtr[0]
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @indexBuffer)
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, @indices.size*4, @indices.ptr, GL_STATIC_DRAW)
  end
  
  def tearDownGL 
    EAGLContext.setCurrentContext(@context)
    
    tmpPtr = Pointer.new(:uchar)
    
    tmpPtr.value = @vertexBuffer
    glDeleteBuffers(1, tmpPtr)
    
    tmpPtr.value = @indexBuffer
    glDeleteBuffers(1, tmpPtr)
    
    @effect = nil
  end
  
  def viewDidLoad
    super

    @context = EAGLContext.alloc.initWithAPI(KEAGLRenderingAPIOpenGLES2)

    if (!@context)
      puts "Failed to create ES context"
    end

    self.view.context = @context
    @rotation = 0
    setupGL
  end
  
  def viewDidUnload
    super
    tearDownGL
    if (EAGLContext.currentContext == @context) 
      EAGLContext.setCurrentContext(nil)
    end
    @context = nil
  end
  
  def glkView(view, drawInRect:rect)   
    glClearColor(@curRed, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    @effect.prepareToDraw
    
    glBindBuffer(GL_ARRAY_BUFFER, @vertexBuffer)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @indexBuffer)

    glEnableVertexAttribArray(GLKVertexAttribPosition)
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 9*4, Pointer.magic_cookie(0))
    
    glEnableVertexAttribArray(GLKVertexAttribColor)
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 9*4, Pointer.magic_cookie(3*4))
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 9*4, Pointer.magic_cookie(7*4));
    
    glDrawElements(GL_TRIANGLES, @indices.size, GL_UNSIGNED_BYTE, Pointer.magic_cookie(0))
  end

  def update
    if (@increasing)
      @curRed +=  1.0 * self.timeSinceLastUpdate
    else 
      @curRed -= 1.0 * self.timeSinceLastUpdate
    end
    if (@curRed >= 1.0)
        @curRed = 1.0
        @increasing = false
    end
    if (@curRed <= 0.0)
      @curRed = 0.0
      @increasing = true
    end
    
    aspect = (view.bounds.size.width / view.bounds.size.height).abs
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
    @effect.transform.projectionMatrix = projectionMatrix
    
    modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)   
    @rotation += 90.0 * self.timeSinceLastUpdate
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(@rotation), 0, 0, 1)
    @effect.transform.modelviewMatrix = modelViewMatrix
  end
  
  def touchesBegan(touches, withEvent:event)
    self.paused = !self.isPaused
  end
  
end