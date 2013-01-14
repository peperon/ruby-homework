class RobotState
  attr_reader :marked

  def initialize(start)
    @current = start
    @marked = []
  end

  def move
    @current += 1
  end

  def mark
    @marked << @current
  end
end

def robot(start = 0, &block)
  state = RobotState.new start
  state.instance_eval &block
  state.marked
end
