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
    @flagged = true
  end

  def to_s
    return "*" unless revealed
    return "M" if @value == "*"
    return "F" if @flagged
    return "_" if @value == 0
    @value.to_s
  end

end
