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
end
