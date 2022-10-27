class Tennis::Game1::OngoingResult
  RESULTS = {
    0 => "Love",
    1 => "Fifteen",
    2 => "Thirty",
    3 => "Forty"
  }.freeze

  def initialize(player_1:, player_2:)
    @player_1 = player_1
    @player_2 = player_2
  end

  def result
    [score_for(@player_1), score_for(@player_2)].join("-")
  end

  def score_for(player)
    RESULTS.fetch(player.points)
  end
end
