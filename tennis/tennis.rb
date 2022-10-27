require "pry"

module Tennis
  class Game1
  end

  class Player
    def initialize(name:, points: 0)
      @name = name
      @points = points
    end

    def won
      @points += 1
    end

    attr_reader :name, :points
  end
end

class TennisGame1
  def initialize(player1_name, player2_name)
    @players = []
    @players << @player_1 = Tennis::Player.new(name: player1_name)
    @players << @player_2 = Tennis::Player.new(name: player2_name)
  end

  def won_point(player_name)
    player = find_player_by_name(player_name)
    player.won
  end

  def score
    result = ""
    if @player_1.points == @player_2.points
      result = {
        0 => "Love-All",
        1 => "Fifteen-All",
        2 => "Thirty-All"
      }.fetch(@player_1.points, "Deuce")
    elsif (@player_1.points >= 4) || (@player_2.points >= 4)
      minusResult = @player_1.points - @player_2.points
      result = if minusResult == 1
        "Advantage #{@player_1.name}"
      elsif minusResult == -1
        "Advantage #{@player_2.name}"
      elsif minusResult >= 2
        "Win for #{@player_1.name}"
      else
        "Win for #{@player_2.name}"
      end
    else
      (1...3).each do |i|
        if i == 1
          tempScore = @player_1.points
        else
          result += "-"
          tempScore = @player_2.points
        end
        result += {
          0 => "Love",
          1 => "Fifteen",
          2 => "Thirty",
          3 => "Forty"
        }[tempScore]
      end
    end
    result
  end

  private

  def find_player_by_name(name)
    @players.find { |p| p.name == name }
  end
end

class TennisGame2
  def initialize(player1Name, player2Name)
    @player1Name = player1Name
    @player2Name = player2Name
    @p1points = 0
    @p2points = 0
  end

  def won_point(playerName)
    if playerName == @player1Name
      p1Score
    else
      p2Score
    end
  end

  def score
    result = ""
    if (@p1points == @p2points) && (@p1points < 3)
      if @p1points == 0
        result = "Love"
      end
      if @p1points == 1
        result = "Fifteen"
      end
      if @p1points == 2
        result = "Thirty"
      end
      result += "-All"
    end
    if (@p1points == @p2points) && (@p1points > 2)
      result = "Deuce"
    end

    p1res = ""
    p2res = ""
    if (@p1points > 0) && (@p2points == 0)
      if @p1points == 1
        p1res = "Fifteen"
      end
      if @p1points == 2
        p1res = "Thirty"
      end
      if @p1points == 3
        p1res = "Forty"
      end
      p2res = "Love"
      result = p1res + "-" + p2res
    end
    if (@p2points > 0) && (@p1points == 0)
      if @p2points == 1
        p2res = "Fifteen"
      end
      if @p2points == 2
        p2res = "Thirty"
      end
      if @p2points == 3
        p2res = "Forty"
      end

      p1res = "Love"
      result = p1res + "-" + p2res
    end

    if (@p1points > @p2points) && (@p1points < 4)
      if @p1points == 2
        p1res = "Thirty"
      end
      if @p1points == 3
        p1res = "Forty"
      end
      if @p2points == 1
        p2res = "Fifteen"
      end
      if @p2points == 2
        p2res = "Thirty"
      end
      result = p1res + "-" + p2res
    end
    if (@p2points > @p1points) && (@p2points < 4)
      if @p2points == 2
        p2res = "Thirty"
      end
      if @p2points == 3
        p2res = "Forty"
      end
      if @p1points == 1
        p1res = "Fifteen"
      end
      if @p1points == 2
        p1res = "Thirty"
      end
      result = p1res + "-" + p2res
    end
    if (@p1points > @p2points) && (@p2points >= 3)
      result = "Advantage " + @player1Name
    end
    if (@p2points > @p1points) && (@p1points >= 3)
      result = "Advantage " + @player2Name
    end
    if (@p1points >= 4) && (@p2points >= 0) && ((@p1points - @p2points) >= 2)
      result = "Win for " + @player1Name
    end
    if (@p2points >= 4) && (@p1points >= 0) && ((@p2points - @p1points) >= 2)
      result = "Win for " + @player2Name
    end
    result
  end

  def setp1Score(number)
    (0..number).each do |i|
      p1Score
    end
  end

  def setp2Score(number)
    (0..number).each do |i|
      p2Score
    end
  end

  def p1Score
    @p1points += 1
  end

  def p2Score
    @p2points += 1
  end
end

class TennisGame3
  def initialize(player1Name, player2Name)
    @p1N = player1Name
    @p2N = player2Name
    @p1 = 0
    @p2 = 0
  end

  def won_point(n)
    if n == @p1N
      @p1 += 1
    else
      @p2 += 1
    end
  end

  def score
    if ((@p1 < 4) && (@p2 < 4)) && (@p1 + @p2 < 6)
      p = ["Love", "Fifteen", "Thirty", "Forty"]
      s = p[@p1]
      @p1 == @p2 ? s + "-All" : s + "-" + p[@p2]
    elsif @p1 == @p2
      "Deuce"
    else
      s = @p1 > @p2 ? @p1N : @p2N
      (@p1 - @p2) * (@p1 - @p2) == 1 ? "Advantage " + s : "Win for " + s
    end
  end
end
