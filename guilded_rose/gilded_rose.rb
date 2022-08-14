require_relative "item"
require_relative "inn_item"
require_relative "aged_brie_item"
require_relative "backstage_pass_item"
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
    else
      Item
    end

    return item if klass == Item

    klass.new(item)
  end

  # Open to modification
  def update_quality
    @items.each do |item|
      item = prepare(item)
      if item.instance_of?(Item)
        update_quality_old(item)
      else
        item.update_quality
      end
    end
  end

  def update_quality_old(item)
    if (item.name != "Aged Brie") && (item.name != "Backstage passes to a TAFKAL80ETC concert")
      if item.quality > 0
        if item.name != "Sulfuras, Hand of Ragnaros"
          item.quality = item.quality - 1
        end
      end
    elsif item.quality < 50
      item.quality = item.quality + 1
      if item.name == "Backstage passes to a TAFKAL80ETC concert"
        if item.sell_in < 11
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
        if item.sell_in < 6
          if item.quality < 50
            item.quality = item.quality + 1
          end
        end
      end
    end
    if item.name != "Sulfuras, Hand of Ragnaros"
      item.sell_in = item.sell_in - 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != "Backstage passes to a TAFKAL80ETC concert"
          if item.quality > 0
            if item.name != "Sulfuras, Hand of Ragnaros"
              item.quality = item.quality - 1
            end
          end
        else
          item.quality = item.quality - item.quality
        end
      elsif item.quality < 50
        item.quality = item.quality + 1
      end
    end
  end
end
