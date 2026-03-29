require "test_helper"

class Annotations::ExportsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "show exports JSON" do
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "Test note")
    get annotations_export_path(format: :json)
    assert_response :success
    assert_equal "application/json", response.media_type
    data = JSON.parse(response.body)
    assert_equal 1, data.size
    assert_equal "Test note", data.first["body"]
  end

  test "show exports CSV" do
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "CSV note")
    get annotations_export_path(format: :csv)
    assert_response :success
    assert_equal "text/csv", response.media_type
    assert_includes response.body, "CSV note"
  end
end
