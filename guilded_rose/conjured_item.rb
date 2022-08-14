class ConjuredItem < InnItem
  def update_quality
    delta = sell_in.positive? ? 2 : 4
    new_quality = quality - delta
    self.quality = new_quality.negative? ? 0 : new_quality
    self.sell_in -= 1
  end
end
