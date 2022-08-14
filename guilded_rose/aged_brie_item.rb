class AgedBrieItem < InnItem
  def update_quality
    return if quality == 50

    delta = sell_in.positive? ? 1 : 2
    self.quality = quality + delta
    self.sell_in -= 1
  end
end
