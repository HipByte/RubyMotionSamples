class Transformer
  def self.withName(name, class:klass, &block)
    if block_given?
      transformer = Transformer.new(&block)
      transformer.build(name, klass)
    end
  end

  def initialize(&dsl_code)
    @transform = @reverse = nil
    if dsl_code.arity == 1      # the arity() check
      dsl_code[self]            # argument expected, pass the object
    else
      instance_eval(&dsl_code)  # no argument, use instance_eval()
    end
  end

  def transform(&block); @transform = block; end

  def reverse(&block); @reverse = block; end

  def build(name, klass)
    transformation, reverse_transformation = @transform, @reverse
    valueTransformer = Class.new(NSValueTransformer) do
      # Objective C can't call methods created dynamically
      # you will need a method created with __def__
      define_method(:transformation) { transformation }
      define_method(:reverse_transformation)  { reverse_transformation }
      define_singleton_method(:klass) { klass.is_a?(String) ? NSClassFromString(klass) : klass }
      define_singleton_method(:reverse_allowed?)  { !reverse_transformation.nil? }

      def self.allowsReverseTransformation; self.reverse_allowed?; end
      def self.transformedValueClass; klass; end

      def transformedValue(value); self.transformation[value];end

      def reverseTransformedValue(value)
        self.reverse_transformation[value]
      end if reverse_transformation
    end

    NSValueTransformer.setValueTransformer(valueTransformer.new, forName: name)
    valueTransformer
  end
end