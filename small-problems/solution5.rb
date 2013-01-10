class Abomination < BasicObject
  def self.const_missing(name)::Object.const_get(name)
  end

  def initialize(*objects)
    @objects = objects
  end

  def method_missing(name, *args, &block)
    first_object = @objects.detect { |object| object.respond_to? name }
    first_object ? first_object.send(name, *args, &block) : super
  end

  def is_a?(type)
    @objects.any? { |object| object.is_a? type } or type == Abomination
  end

  def kind_of?(type)
    is_a? type
  end
end
