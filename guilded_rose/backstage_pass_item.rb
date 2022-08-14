class BackstagePassItem < InnItem
  def update_quality
    if sell_in < 1
      self.quality = 0
    else
      self.quality += if sell_in < 6
        3
      elsif sell_in < 11
        2
      else
        1
      end

      self.quality = 50 if quality > 50
    end

    self.sell_in -= 1
  end
end
