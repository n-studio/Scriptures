require "test_helper"

class FeaturedPassageTest < ActiveSupport::TestCase
  test "current_featured returns active featured passage" do
    fp = FeaturedPassage.create!(
      passage: passages(:genesis_one_one),
      title: "In the beginning",
      context: "The Priestly creation account opens with a cosmic ordering.",
      active_from: 1.day.ago
    )
    assert_equal fp, FeaturedPassage.current_featured
  end

  test "current_featured skips future passages" do
    FeaturedPassage.create!(
      passage: passages(:genesis_one_one),
      title: "Future",
      context: "Not yet active.",
      active_from: 1.day.from_now
    )
    assert_nil FeaturedPassage.current_featured
  end

  test "current_featured skips expired passages" do
    FeaturedPassage.create!(
      passage: passages(:genesis_one_one),
      title: "Expired",
      context: "No longer active.",
      active_from: 10.days.ago,
      active_until: 1.day.ago
    )
    assert_nil FeaturedPassage.current_featured
  end
end
