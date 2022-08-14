class InnItem
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def quality
    item.quality
  end

  def quality=(val)
    item.quality = val
  end

  def sell_in
    item.sell_in
  end

  def sell_in=(val)
    item.sell_in = val
  end

  def update_quality
    delta = sell_in.positive? ? 1 : 2
    new_quality = quality - delta
    self.quality = new_quality.negative? ? 0 : new_quality
    self.sell_in -= 1
  end
end
