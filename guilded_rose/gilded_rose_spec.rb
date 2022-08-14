require "csv"
require "pry"
require File.join(File.dirname(__FILE__), "gilded_rose")

describe GildedRose do
  describe "#update_quality" do
    context "when ConjuredItem" do
      let(:item) { Item.new("Conjured Mana Pot", 3, 20) }
      let(:gilded_rose) { GildedRose.new([item]) }

      context "after 1 day" do
        before { gilded_rose.update_quality }

        it "updates" do
          expect(item.sell_in).to eq(2)
          expect(item.quality).to eq(18)
        end
      end

      context "after 4 days" do
        before { 4.times { gilded_rose.update_quality } }

        it "updates" do
          expect(item.sell_in).to eq(-1)
          expect(item.quality).to eq(10)
        end
      end

      context "after 10 days" do
        before { 10.times { gilded_rose.update_quality } }

        it "updates" do
          expect(item.sell_in).to eq(-7)
          expect(item.quality).to eq(0)
        end
      end
    end
  end

  describe "Test update_quality against snapshot" do
    items_map = CSV
      .read("snapshot.csv", headers: true, col_sep: ";")
      .group_by { |row| row["id"] }

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
