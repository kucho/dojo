#!/usr/bin/env ruby

require "csv"
require "pry"
require_relative "item"

class SnapshotGenerator
  def initialize(days)
    @days = days
  end

  def raw_data
    @raw_data ||= `./texttest_fixture.rb #{@days}`
  end

  def generate
    current_day = nil
    day_data = {}

    raw_data.each_line do |line|
      next if line.strip.empty? || line == table_header

      day_indicator = extract_day_indicator(line)
      if day_indicator
        current_day = day_indicator["day"].to_i
      else
        day_data[current_day] ||= []
        day_data[current_day] << create_item(line)
      end
    end

    day_data
  end

  def export
    data = generate

    CSV.open("snapshot.csv", "w",
      col_sep: ";", write_headers: true,
      headers: ["day", "id", "name", "sell_in", "quality"]) do |csv|
      data.each_pair do |day, items|
        items.each_with_index do |item, index|
          csv << [day, index, item.name, item.sell_in, item.quality]
        end
      end
    end
  end

  private

  def create_item(line)
    name, sell_in, quality = line.split(";")

    Item.new(name.strip, sell_in.strip.to_i, quality.strip.to_i)
  end

  def table_header
    @table_header ||= "name, sellIn, quality\n"
  end

  def extract_day_indicator(line)
    /^-------- day (?<day>\d+) --------$/.match(line)
  end
end

days = 2
if ARGV.size > 0
  days = ARGV[0].to_i
end

SnapshotGenerator.new(days).export
