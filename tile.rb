class Tile
  attr_reader :value, :revealed

  def initialize(value)
    @value = value
    @revealed = false
    @flagged = false
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged = !@flagged
    @flagged ? -1 : 1
  end

  def to_s
    return "F" if @flagged && !@revealed
    return "*" unless @revealed
    return "M" if @value == "*"
    return "_" if @value == 0
    @value.to_s
  end

end
