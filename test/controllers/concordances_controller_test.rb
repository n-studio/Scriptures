require "test_helper"

class ConcordancesControllerTest < ActionDispatch::IntegrationTest
  test "show returns concordance data" do
    entry = LexiconEntry.first
    skip "No lexicon entries in fixtures" unless entry

    get concordance_path(entry)
    assert_response :success
    data = JSON.parse(response.body)
    assert data.key?("lemma")
    assert data.key?("results")
  end
end
