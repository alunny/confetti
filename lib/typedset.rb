require "set"

# based on RestricedSet from Ruby's stdlib, cf
# http://github.com/ruby/ruby/blob/72ef219804e5524848170a197887a95718334e2a/lib/set.rb#L627-717
# not sure why it's been commented out
# I should follow these things

class TypedSet < Set
  attr_reader :klass
  alias set_class klass

  def initialize (klass, *args)
    raise ArgumentError, "require a Class object" unless klass.class == Class
    @klass = klass
    super args
  end

  def add o
    raise ArgumentError, "members must be of class #{@klass}" unless o.class == @klass
    super o
  end
  alias << add
end
