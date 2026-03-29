require "test_helper"

class DiscoverControllerTest < ActionDispatch::IntegrationTest
  test "index renders without auth" do
    get discover_path
    assert_response :success
    assert_select "h1", "Discover"
  end

  test "index shows featured passage" do
    FeaturedPassage.create!(
      passage: passages(:genesis_one_one),
      title: "In the beginning",
      context: "The Priestly account.",
      active_from: Date.current
    )
    get discover_path
    assert_response :success
    assert_select "h2", "In the beginning"
  end

  test "stats requires auth" do
    get discover_stats_path
    assert_redirected_to new_session_path
  end

  test "stats renders for authenticated user" do
    sign_in_as(users(:scholar))
    get discover_stats_path
    assert_response :success
    assert_select "h1", "Reading Statistics"
  end

  test "stats shows correct counts" do
    sign_in_as(users(:scholar))
    users(:scholar).reading_progresses.create!(passage: passages(:genesis_one_one), read_at: Time.current, time_spent_seconds: 120)
    get discover_stats_path
    assert_response :success
    assert_select "div.text-3xl", "1"
  end

  test "word_frequency renders" do
    get discover_word_frequency_path
    assert_response :success
    assert_select "h1", "Word Frequency"
  end

  test "word_frequency accepts corpus filter" do
    get discover_word_frequency_path(corpus_slug: "bible")
    assert_response :success
  end

  test "exploration requires auth" do
    get discover_exploration_path
    assert_redirected_to new_session_path
  end

  test "exploration renders for authenticated user" do
    sign_in_as(users(:scholar))
    get discover_exploration_path
    assert_response :success
    assert_select "h1", "Exploration Map"
  end
end
