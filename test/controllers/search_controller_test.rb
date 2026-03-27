require "test_helper"

class SearchControllerTest < ActionDispatch::IntegrationTest
  test "index renders without query" do
    get search_path
    assert_response :success
  end

  test "fulltext search finds matching passages" do
    get search_path(q: "beginning")
    assert_response :success
    assert_select "span.font-bold", '"beginning"'
  end

  test "fulltext search with corpus scope" do
    get search_path(q: "God", scope: "corpus", corpus_slug: "bible")
    assert_response :success
  end

  test "concordance mode" do
    get search_path(q: "beginning", mode: "concordance")
    assert_response :success
  end

  test "concordance mode with translation filter" do
    get search_path(q: "beginning", mode: "concordance", translation: "KJV")
    assert_response :success
  end

  test "lemma search by strongs number" do
    get search_path(q: "H7225", mode: "lemma")
    assert_response :success
  end

  test "lemma search by lemma text" do
    get search_path(q: "רֵאשִׁית", mode: "lemma")
    assert_response :success
  end

  test "empty query returns no results" do
    get search_path(q: "")
    assert_response :success
  end
end
