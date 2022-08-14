#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), "gilded_rose")

items = [
  Item.new(name = "+5 Dexterity Vest", sell_in = 10, quality = 20),
  Item.new(name = "Aged Brie", sell_in = 2, quality = 0),
  Item.new(name = "Elixir of the Mongoose", sell_in = 5, quality = 7),
  Item.new(name = "Sulfuras, Hand of Ragnaros", sell_in = 0, quality = 80),
  Item.new(name = "Sulfuras, Hand of Ragnaros", sell_in = -1, quality = 80),
  Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 15, quality = 20),
  Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 10, quality = 49),
  Item.new(name = "Backstage passes to a TAFKAL80ETC concert", sell_in = 5, quality = 49),
  # This Conjured item does not work properly yet
  Item.new(name = "Conjured Mana Cake", sell_in = 3, quality = 6) # <-- :O
]

days = 2
if ARGV.size > 0
  days = ARGV[0].to_i + 1
end

csv_separators_count = 2

gilded_rose = GildedRose.new items
(0...days).each do |day|
  puts "-------- day #{day} --------"
  puts "name, sellIn, quality"
  items.each do |item|
    item_formatted = item.to_s
    separators_found = 0

    # Replace , with ; to avoid formatting issues while parsing it as csv
    (item_formatted.size - 1).downto(0) do |index|
      break if separators_found == csv_separators_count

      if item_formatted[index] == ","
        item_formatted[index] = ";"
        separators_found += 1
      end
    end

    puts item_formatted
  end
  puts ""
  gilded_rose.update_quality
end
