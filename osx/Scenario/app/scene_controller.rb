class SceneController < NSViewController
      
  def title; "World Scene"; end
  
  def loadView
    self.view = SCNView.alloc.init.tap do |view|
      view.identifier = "ContentView"
      view.backgroundColor = NSColor.blackColor
      filepath = NSBundle.mainBundle.pathForResource "earthmoontextured", ofType:"dae"
      if filepath
        url = NSURL.fileURLWithPath filepath
        view.scene = SCNScene.sceneWithURL url, options:nil, error:nil
      end
    end

    attributes = [
      NSOpenGLPFAAccelerated,
      NSOpenGLPFAColorSize, 32,
      NSOpenGLPFADepthSize, 24,
    ]

    attributes_pointer = Pointer.new("I", attributes.size)
    attributes.each_with_index do |v, i|
      attributes_pointer[i] = v
    end

    self.view.pixelFormat = NSOpenGLPixelFormat.alloc.initWithAttributes(attributes_pointer)
    self.view.openGLContext = NSOpenGLContext.alloc.initWithFormat(self.view.pixelFormat, shareContext:nil)

    Dispatch::Queue.current.after(0.1) { configure }
  end
    
  def configure
    retrieveEarthMaterial
    retrieveLightNode
    retrieveMoonMaterial
    loadMoonNormalMap
    createProgram
    loadTextures
    insertFloor
  end
  
  
  def loadTextureWithName filename, andExtension:extension
    game_bundle = CFBundleGetMainBundle()
    subdirectory  = nil
    file_location = CFBundleCopyResourceURL(game_bundle, filename, extension, subdirectory)
    myImageSourceRef = CGImageSourceCreateWithURL(file_location, nil)
    myImageRef = CGImageSourceCreateImageAtIndex(myImageSourceRef, 0, nil)
    
    
    myTextureName = Pointer.new('I')
    
    width  = CGImageGetWidth(myImageRef) 
    height = CGImageGetHeight(myImageRef)
    rect   = CGRect.new([0, 0], [width, height])
    
    bitmap_bytes_per_row = width * 4
    bitmap_byte_count = bitmap_bytes_per_row * height
    myData = Pointer.new(:char, bitmap_byte_count)
    
    space = CGColorSpaceCreateDeviceRGB()
    myBitmapContext = CGBitmapContextCreate(myData, width, height, 8, width*4, space, KCGBitmapByteOrder32Host | KCGImageAlphaPremultipliedFirst)
    CGContextSetBlendMode(myBitmapContext, KCGBlendModeCopy)
    CGContextDrawImage(myBitmapContext, rect, myImageRef)
    
    glPixelStorei(GL_UNPACK_ROW_LENGTH, width)
    glPixelStorei(GL_UNPACK_ALIGNMENT, 1)
    glGenTextures(1, myTextureName)
    glBindTexture(GL_TEXTURE_2D, myTextureName.value)
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP_TO_EDGE)
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP_TO_EDGE)
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA8, width, height, 0, GL_BGRA_EXT, GL_UNSIGNED_INT_8_8_8_8_REV, myData)
    myData = nil
    p myTextureName.value
    myTextureName
  end
  
  
  def retrieveEarthMaterial
    rootNode  = self.view.scene.rootNode
    earthNode = rootNode.childNodeWithName "earth", recursively:false
    geometry  = earthNode.geometry
    @earthMaterial = geometry.firstMaterial
  end
  
  
  def retrieveLightNode
    rootNode = self.view.scene.rootNode
    @lightNode = rootNode.childNodeWithName "light", recursively:false
  end
  
  
  def retrieveMoonMaterial
    rootNode = self.view.scene.rootNode
    moonNode = rootNode.childNodeWithName "moon", recursively:false
    @moonMaterial = moonNode.geometry.firstMaterial
    @moonMaterial.normal.minificationFilter = SCNFilterModeLinear
    @moonMaterial.normal.magnificationFilter = SCNFilterModeLinear
    @moonMaterial.normal.mipFilter = SCNFilterModeLinear
  end
  
  
  def loadMoonNormalMap
    normalMapPath = NSBundle.mainBundle.pathForResource "moonnormal1k", ofType:"jpg"
    @moonNormalMap ||= NSImage.alloc.initWithContentsOfFile normalMapPath
  end
  
  
  def createProgram
    program = SCNProgram.alloc.init
    vertexPath = NSBundle.mainBundle.pathForResource "vertex", ofType:"prog"
    vertexShader = NSString.stringWithContentsOfFile vertexPath, encoding:NSUTF8StringEncoding, error:nil
    
    fragmentPath = NSBundle.mainBundle.pathForResource "fragment", ofType:"prog"
    fragmentShader = NSString.stringWithContentsOfFile fragmentPath, encoding:NSUTF8StringEncoding, error:nil
    
    program.vertexShader = vertexShader
    program.fragmentShader = fragmentShader
    program.delegate = self
    
    program.setSemantic SCNGeometrySourceSemanticVertex, forSymbol:"a_Position", options:nil
    program.setSemantic SCNGeometrySourceSemanticNormal, forSymbol:"a_Normal", options:nil
    program.setSemantic SCNGeometrySourceSemanticTexcoord, forSymbol:"a_TextureCoordinate", options:nil
    program.setSemantic SCNModelViewProjectionTransform, forSymbol:"u_ModelViewProjectionMatrix", options:nil
    program.setSemantic SCNModelViewTransform, forSymbol:"u_ModelViewMatrix", options:nil
    program.setSemantic SCNViewTransform, forSymbol:"u_ViewMatrix", options:nil
    program.setSemantic SCNNormalTransform, forSymbol:"u_NormalMatrix", options:nil
    @earthProgram = program
  end
  
  
  def loadTextures
    # Loading the textures for earth manually because the own shader needs them to be bound manually
    @normalMap   = self.loadTextureWithName "earthnormal1k", andExtension:"jpg"
    @colorMap    = self.loadTextureWithName "earthmap1k", andExtension:"jpg"
    @specularMap = self.loadTextureWithName "earthspec1k", andExtension:"jpg"
    @nightMap    = self.loadTextureWithName "earthlights1k", andExtension:"jpg"
  end
  
  
  def insertFloor
    floorNode = SCNNode.node
    floorNode.position = SCNVector3Make(0.0, 0.0, -3.0);
    # Creating floor geometry
    floor = SCNFloor.floor
    floor.reflectivity = 0.1
    floorNode.geometry = floor
    # Adding the floor to the scene graph
    self.view.scene.rootNode.addChildNode floorNode
    
    # Getting the first material of the floor geometry
    material = floor.firstMaterial
    # Setting the wood texture as diffuest content of floor material
    texturePath = NSBundle.mainBundle.pathForResource "wood", ofType:"jpg"
    image = NSImage.alloc.initWithContentsOfFile texturePath
    material.diffuse.contents = image
  end
  
  # SCNProgram delegate
  def program program, bindValueForSymbol:symbol, atLocation:location, programID:programID, renderer:renderer    
    # Camera position
    if symbol == "u_EyePosition"
      position = self.view.pointOfView.position
      glUniform3f(location, position.x, position.y, position.z)
      return true
    end
    
    # Light position
    if symbol == "u_LightPosition"
      position = @lightNode.position
      glUniform3f(location, position.x, position.y, position.z)
      return true
    end
    
    # Normal texture
    if symbol == "u_TextureNormal"
      glUniform1i(location, 0)
      glActiveTexture(GL_TEXTURE0);
      glEnable(GL_TEXTURE_2D);
      glBindTexture(GL_TEXTURE_2D, @normalMap.value)
      return true
    end
    
    # Standard color texture
    if symbol == "u_TextureColor"
      glUniform1i(location, 1)
      glActiveTexture (GL_TEXTURE1)
      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, @colorMap.value)
      return true
    end
    
    # Texture showing the illuminates cities
    if symbol == "u_TextureNight"
      glUniform1i(location, 2)
      glActiveTexture(GL_TEXTURE2)
      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, @nightMap.value)
      return true
    end
    
    # Specular map, so only the sea reflects light
    if symbol == "u_TextureSpecular"
      glUniform1i(location, 3)
      glActiveTexture(GL_TEXTURE3)
      glEnable(GL_TEXTURE_2D)
      glBindTexture(GL_TEXTURE_2D, @specularMap.value)
      return true
    end
    
    false
  end
  
  
  def program program, unbindValueForSymbol:symbol, atLocation:location, programID:programID, renderer:renderer
  end
  
  def program program, handleError:error
    NSLog("error %@", error.localizedDescription)
  end
  
  def change_shader sender
    @earthMaterial.program, @moonMaterial.normal.contents = if @earthMaterial.program
      [nil, nil]
    else
      [@earthProgram, @moonNormalMap]
    end
    
  end
end