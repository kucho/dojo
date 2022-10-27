module Tennis
  class Game1
    require_relative "player"
    require_relative "draw_result"
    require_relative "match_point_result"
    require_relative "ongoing_result"

    def initialize(player1_name, player2_name)
      @players = []
      @players << @player_1 = Player.new(name: player1_name)
      @players << @player_2 = Player.new(name: player2_name)
    end

    def won_point(player_name)
      player = find_player_by_name(player_name)
      player.won
    end

    def score
      if draw?
        DrawResult.new(@player_1.points).result
      elsif match_point?
        MatchPointResult.new(player_1: @player_1, player_2: @player_2).result
      else
        OngoingResult.new(player_1: @player_1, player_2: @player_2).result
      end
    end

    private

    def draw?
      @player_1.points == @player_2.points
    end

    def match_point?
      @player_1.points >= 4 || @player_2.points >= 4
    end

    def find_player_by_name(name)
      @players.find { |p| p.name == name }
    end
  end
end
