class Branch
  def initialize(length, weight)
    @length = length
    @weight = weight
  end

  def weight
    return @weight.weight if @weight.respond_to? :weight
    @weight
  end

  def balanced?
    return @weight.balanced? if @weight.respond_to? :balanced?
    true
  end

  def moment
    weight * @length
  end
end

class BinaryMobile
  def initialize(left, right)
    @left  = left
    @right = right
  end

  def weight
    @left.weight + @right.weight
  end

  def balanced?
    @left.moment == @right.moment and @left.balanced? and @right.balanced?
  end
end
