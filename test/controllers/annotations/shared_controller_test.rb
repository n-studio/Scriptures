require "test_helper"

class Annotations::SharedControllerTest < ActionDispatch::IntegrationTest
  test "show displays public annotations" do
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "Public note", public: true)
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "Private note", public: false)

    get annotations_shared_path(user_id: users(:scholar))
    assert_response :success
    assert_select "p", /Public note/
    assert_select "p", { text: /Private note/, count: 0 }
  end

  test "show works without auth" do
    users(:scholar).annotations.create!(passage: passages(:genesis_one_one), body: "Shared", public: true)
    get annotations_shared_path(user_id: users(:scholar))
    assert_response :success
  end
end
