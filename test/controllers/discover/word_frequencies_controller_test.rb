require "test_helper"

class Discover::WordFrequenciesControllerTest < ActionDispatch::IntegrationTest
  test "show renders without auth" do
    get discover_word_frequency_path
    assert_response :success
    assert_select "h1", "Word Frequency"
  end

  test "show accepts corpus filter" do
    get discover_word_frequency_path(corpus_slug: "bible")
    assert_response :success
  end
end
