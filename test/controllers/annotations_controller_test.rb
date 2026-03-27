require "test_helper"

class AnnotationsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create saves annotation with tags" do
    assert_difference "Annotation.count", 1 do
      post annotations_path, params: {
        annotation: {
          passage_id: passages(:genesis_one_one).id,
          body: "Interesting verse",
          tag_list: "creation, priestly"
        }
      }
    end
    annotation = Annotation.last
    assert_equal "Interesting verse", annotation.body
    assert_equal 2, annotation.tags.count
  end

  test "destroy removes annotation" do
    annotation = users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "test")
    assert_difference "Annotation.count", -1 do
      delete annotation_path(annotation)
    end
  end
end
