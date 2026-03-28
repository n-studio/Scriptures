require "test_helper"

class CurriculumTest < ActiveSupport::TestCase
  test "valid curriculum" do
    curriculum = users(:scholar).curricula.build(name: "Hebrew Bible Intro")
    assert curriculum.valid?
  end

  test "requires name" do
    curriculum = users(:scholar).curricula.build(name: "")
    assert_not curriculum.valid?
  end

  test "validates curriculum_type inclusion" do
    curriculum = users(:scholar).curricula.build(name: "Test", curriculum_type: "invalid")
    assert_not curriculum.valid?
  end

  test "allows blank curriculum_type" do
    curriculum = users(:scholar).curricula.build(name: "Test", curriculum_type: "")
    assert curriculum.valid?
  end

  test "progress_for returns percentage" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    passage = passages(:genesis_one_one)
    curriculum.curriculum_items.create!(passage: passage, position: 1)
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_two), position: 2)

    assert_equal 0, curriculum.progress_for(users(:scholar))

    users(:scholar).reading_progresses.create!(passage: passage, read_at: Time.current)
    assert_equal 50, curriculum.progress_for(users(:scholar))
  end
end
