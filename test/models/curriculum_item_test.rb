require "test_helper"

class CurriculumItemTest < ActiveSupport::TestCase
  test "valid item" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    item = curriculum.curriculum_items.build(passage: passages(:genesis_one_one), position: 1)
    assert item.valid?
  end

  test "requires position" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    item = curriculum.curriculum_items.build(passage: passages(:genesis_one_one), position: nil)
    assert_not item.valid?
  end

  test "unique passage per curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    dup = curriculum.curriculum_items.build(passage: passages(:genesis_one_one), position: 2)
    assert_not dup.valid?
  end
end
