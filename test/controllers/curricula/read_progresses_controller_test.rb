require "test_helper"

class Curricula::ReadProgressesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create marks passage as read" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "ReadingProgress.count", 1 do
      post curricula_read_progresses_path(curriculum_id: curriculum.id, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "destroy marks passage as unread" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current)
    assert_difference "ReadingProgress.count", -1 do
      delete curricula_read_progress_path(id: passages(:genesis_one_one).id, curriculum_id: curriculum.id, passage_id: passages(:genesis_one_one).id)
    end
  end
end
