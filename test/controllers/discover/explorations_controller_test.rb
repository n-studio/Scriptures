require "test_helper"

class Discover::ExplorationsControllerTest < ActionDispatch::IntegrationTest
  test "show requires auth" do
    get discover_exploration_path
    assert_redirected_to new_session_path
  end

  test "show renders exploration map" do
    sign_in_as(users(:scholar))
    get discover_exploration_path
    assert_response :success
    assert_select "h1", "Exploration Map"
  end
end
