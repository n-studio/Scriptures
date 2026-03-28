require "test_helper"

class CurriculaControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "index lists curricula" do
    users(:scholar).curricula.create!(name: "Hebrew Bible Intro")
    get curricula_path
    assert_response :success
    assert_select "div", /Hebrew Bible Intro/
  end

  test "new renders form" do
    get new_curriculum_path
    assert_response :success
    assert_select "form"
  end

  test "create makes a new curriculum" do
    assert_difference "Curriculum.count", 1 do
      post curricula_path, params: { curriculum: { name: "NT Source Criticism" } }
    end
    assert_redirected_to curriculum_path(Curriculum.last)
  end

  test "show renders curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    get curriculum_path(curriculum)
    assert_response :success
  end

  test "show renders public curriculum without auth" do
    sign_out
    curriculum = users(:scholar).curricula.create!(name: "Public", public: true)
    get curriculum_path(curriculum)
    assert_response :success
  end

  test "show rejects private curriculum without auth" do
    sign_out
    curriculum = users(:scholar).curricula.create!(name: "Private", public: false)
    get curriculum_path(curriculum)
    assert_redirected_to root_path
  end

  test "edit renders form" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    get edit_curriculum_path(curriculum)
    assert_response :success
  end

  test "update modifies curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Old")
    patch curriculum_path(curriculum), params: { curriculum: { name: "New" } }
    assert_redirected_to curriculum_path(curriculum)
    assert_equal "New", curriculum.reload.name
  end

  test "destroy deletes curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    assert_difference "Curriculum.count", -1 do
      delete curriculum_path(curriculum)
    end
  end

  test "add_passage adds to curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    assert_difference "CurriculumItem.count", 1 do
      post add_passage_curriculum_path(curriculum, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "remove_passage removes from curriculum" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "CurriculumItem.count", -1 do
      delete remove_passage_curriculum_path(curriculum, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "mark_read creates reading progress" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "ReadingProgress.count", 1 do
      post mark_read_curriculum_path(curriculum, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "mark_unread removes reading progress" do
    curriculum = users(:scholar).curricula.create!(name: "Test")
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current)
    assert_difference "ReadingProgress.count", -1 do
      delete mark_unread_curriculum_path(curriculum, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "export returns text file" do
    curriculum = users(:scholar).curricula.create!(name: "Test Curriculum")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    get export_curriculum_path(curriculum, format: :text)
    assert_response :success
    assert_equal "text/plain", response.media_type
    assert_includes response.body, "Test Curriculum"
  end
end
