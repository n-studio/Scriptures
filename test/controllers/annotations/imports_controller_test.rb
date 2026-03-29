require "test_helper"

class Annotations::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create imports annotations from JSON" do
    json = [{ corpus: "bible", scripture: "genesis", chapter: 1, verse: 1, body: "Imported" }].to_json
    file = Rack::Test::UploadedFile.new(StringIO.new(json), "application/json", false, original_filename: "ann.json")

    assert_difference "Annotation.count", 1 do
      post annotations_import_path, params: { file: file }
    end
    assert_equal "Imported", Annotation.last.body
  end

  test "create deduplicates existing annotations" do
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "Existing")
    json = [{ corpus: "bible", scripture: "genesis", chapter: 1, verse: 1, body: "Existing" }].to_json
    file = Rack::Test::UploadedFile.new(StringIO.new(json), "application/json", false, original_filename: "ann.json")

    assert_no_difference "Annotation.count" do
      post annotations_import_path, params: { file: file }
    end
  end

  test "create rejects non-JSON files" do
    file = Rack::Test::UploadedFile.new(StringIO.new("not json"), "text/plain", false, original_filename: "bad.txt")
    post annotations_import_path, params: { file: file }
    assert_redirected_to annotations_path(user_id: users(:scholar))
  end
end
