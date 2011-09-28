require "set"

class TypedSet < Set
  attr_reader :set_class

  def initialize (klass, *args)
    raise ArgumentError, "require a class object" unless klass.class == Class
    @set_class = klass
    super args
  end

  def add o
    unless o.class == @set_class
      raise ArgumentError, "members must be of class #{ @set_class }"
    end

    super o
  end
  alias << add
end
