class Tennis::Game1::MatchPointResult
  def initialize(player_1:, player_2:)
    @player_1 = player_1
    @player_2 = player_2
  end

  def result
    score_diff = @player_1.points - @player_2.points
    leading_player = score_diff.positive? ? @player_1 : @player_2
    condition = score_diff.abs == 1 ? "Advantage " : "Win for "
    condition + leading_player.name
  end
end
