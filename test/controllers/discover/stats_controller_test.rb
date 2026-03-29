require "test_helper"

class Discover::StatsControllerTest < ActionDispatch::IntegrationTest
  test "show requires auth" do
    get discover_stats_path
    assert_redirected_to new_session_path
  end

  test "show renders stats" do
    sign_in_as(users(:scholar))
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current, time_spent_seconds: 60)
    get discover_stats_path
    assert_response :success
    assert_select "div.text-3xl", "1"
  end
end
