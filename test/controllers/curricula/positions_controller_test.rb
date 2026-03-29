require "test_helper"

class Curricula::PositionsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "update reorders items" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    item1 = curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    item2 = curriculum.curriculum_items.create!(passage: passages(:genesis_one_two), position: 2)

    patch curricula_positions_path(curriculum_id: curriculum.id),
      params: { item_ids: [ item2.id, item1.id ] },
      as: :json

    assert_response :ok
    assert_equal 2, item1.reload.position
    assert_equal 1, item2.reload.position
  end
end
