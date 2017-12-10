class Tile
  attr_reader :value, :revealed

  def initialize(value)
    @value = value
    @revealed = false
  end

  def reveal
    @revealed = true
  end

end
