require_relative "item"
require_relative "legendary_item"

class GildedRose
  def initialize(items)
    @items = items
  end

  def prepare(item)
    return item if item.instance_of?(Item)

    item_properties = [item.name, item.sell_in, item.quality]

    klass = if item.name.include?("Sulfuras")
      LegendaryItem
    end

    klass.new(*item_properties)
  end

  # Open to modification
  def update_quality
    @items.each do |item|
      item = prepare(item)
      case item
      when LegendaryItem
        item.update_quality
      else
        update_quality_old(item)
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
