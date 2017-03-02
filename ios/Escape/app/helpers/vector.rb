module Escape # Vector
  module Vector    

    module_function

    def add(a, b)
      CGPoint.new(a.x + b.x, a.y + b.y)
    end

    def subtract(a, b)
      CGPoint.new(a.x - b.x, a.y - b.y)
    end

    def resultantLength(a)
      Math.sqrt(a.x * a.x + a.y * a.y)
    end

    def multiply(a, withScalar:scalar)
      CGPoint.new(a.x * scalar, a.y * scalar)
    end

    def normalize(a)
      length = resultantLength(a)
      CGPoint.new(a.x / length, a.y / length)
    end

  end
end