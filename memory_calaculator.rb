require 'objspace'

class MemoryCalaculator
  attr_reader :object

  def initialize(object)
    @object = object
  end

  def call
    ObjectSpace.memsize_of(object)
  end
end
