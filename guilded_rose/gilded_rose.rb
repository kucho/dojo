require_relative "item"
require_relative "inn_item"
require_relative "aged_brie_item"
require_relative "backstage_pass_item"
require_relative "conjured_item"
require_relative "legendary_item"

class GildedRose
  def initialize(items)
    @items = items
  end

  def prepare(item)
    klass = if item.name.include?("Sulfuras")
      LegendaryItem
    elsif item.name.include?("Aged")
      AgedBrieItem
    elsif item.name.include?("Backstage")
      BackstagePassItem
    elsif item.name.include?("Conjured")
      ConjuredItem
    else
      InnItem
    end

    klass.new(item)
  end

  # Open to modification
  def update_quality
    @items.each do |item|
      item = prepare(item)
      item.update_quality
    end
  end
end
