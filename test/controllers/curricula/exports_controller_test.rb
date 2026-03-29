require "test_helper"

class Curricula::ExportsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "show returns plain text export" do
    curriculum = users(:scholar).curricula.create!(name: "Test Curriculum")
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    get curricula_export_path(curriculum_id: curriculum.id, format: :text)
    assert_response :success
    assert_equal "text/plain", response.media_type
    assert_includes response.body, "Test Curriculum"
    assert_includes response.body, "Genesis"
  end

  test "show works for public curriculum without auth" do
    sign_out
    curriculum = users(:scholar).curricula.create!(name: "Public", public: true)
    curriculum.curriculum_items.create!(passage: passages(:genesis_one_one), position: 1)
    get curricula_export_path(curriculum_id: curriculum.id, format: :text)
    assert_response :success
  end

  test "show rejects private curriculum without auth" do
    sign_out
    curriculum = users(:scholar).curricula.create!(name: "Private", public: false)
    get curricula_export_path(curriculum_id: curriculum.id, format: :text)
    assert_redirected_to root_path
  end
end
