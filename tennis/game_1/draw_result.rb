class Tennis::Game1::DrawResult
  RESULTS = {
    0 => "Love-All",
    1 => "Fifteen-All",
    2 => "Thirty-All"
  }.freeze

  def initialize(points)
    @points = points
  end

  def result
    RESULTS.fetch(@points, "Deuce")
  end
end
