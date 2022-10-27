class Tennis::Game1::Player
  def initialize(name:, points: 0)
    @name = name
    @points = points
  end

  def won
    @points += 1
  end

  attr_reader :name, :points
end
