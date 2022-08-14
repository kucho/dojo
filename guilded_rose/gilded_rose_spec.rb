require "csv"
require "pry"
require File.join(File.dirname(__FILE__), "gilded_rose")

describe GildedRose do
  items_map = CSV
    .read("snapshot.csv", headers: true, col_sep: ";")
    .group_by { |row| row["id"] }

  describe "#update_quality" do
    items_map.each_pair do |id, days_statuses|
      initial_state = days_statuses.shift
      item = Item.new(initial_state["name"], initial_state["sell_in"].to_i, initial_state["quality"].to_i)
      gilded_rose = GildedRose.new([item])

      describe "examples for #{initial_state["name"]}_#{id}" do
        days_statuses.each do |day_status|
          context "on day #{day_status["day"]}" do
            it "updates as expected" do
              gilded_rose.update_quality
              expect(item.name).to eq day_status["name"]
              expect(item.sell_in).to eq day_status["sell_in"].to_i
              expect(item.quality).to eq day_status["quality"].to_i
            end
          end
        end
      end
    end
  end
end
