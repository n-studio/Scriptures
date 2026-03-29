require "test_helper"

class Curricula::PassagesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create adds passage to curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    assert_difference "CurriculumItem.count", 1 do
      post curricula_passages_path(curriculum_id: curriculum.id, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "destroy removes passage from curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "CurriculumItem.count", -1 do
      delete curricula_passage_path(id: passages(:genesis_one_one).id, curriculum_id: curriculum.id, passage_id: passages(:genesis_one_one).id)
    end
  end
end
