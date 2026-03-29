require "test_helper"

class ReadingProgresses::TimesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create increments time spent" do
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current)
    post reading_progresses_time_path, params: { passage_id: passages(:genesis_one_one).id, seconds: 30 }
    assert_response :ok
    assert_equal 30, users(:scholar).reading_progresses.find_by(passage: passages(:genesis_one_one)).time_spent_seconds
  end

  test "create clamps to max 3600" do
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current)
    post reading_progresses_time_path, params: { passage_id: passages(:genesis_one_one).id, seconds: 9999 }
    assert_response :ok
    assert_equal 3600, users(:scholar).reading_progresses.find_by(passage: passages(:genesis_one_one)).time_spent_seconds
  end

  test "create ignores missing reading progress" do
    post reading_progresses_time_path, params: { passage_id: passages(:genesis_one_one).id, seconds: 30 }
    assert_response :ok
  end
end
