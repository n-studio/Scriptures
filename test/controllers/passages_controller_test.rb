require "test_helper"

class PassagesControllerTest < ActionDispatch::IntegrationTest
  test "show renders default reading view" do
    get root_path
    assert_response :success
  end

  test "show renders with corpus/scripture/division" do
    get reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1)
    assert_response :success
    assert_select ".scripture-text"
  end

  test "show with translation param" do
    get reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1, t: [ "KJV" ])
    assert_response :success
  end

  test "show with parallel mode" do
    get reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1, parallel: "1", t: %w[KJV WLC])
    assert_response :success
  end

  test "show with diff mode" do
    get reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1, diff: "1", t: %w[KJV WLC])
    assert_response :success
  end

  test "jump resolves valid reference" do
    get jump_path(ref: "Genesis 1:1")
    assert_redirected_to reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1)
  end

  test "jump redirects back for invalid reference" do
    get jump_path(ref: "Nonexistent 99:99")
    assert_redirected_to root_path
  end

  test "prev/next navigation links present" do
    get reading_path(corpus_slug: "bible", scripture_slug: "genesis", division_number: 1)
    assert_response :success
    # Chapter 1 should have a next link to chapter 2
    assert_select "a[href*='genesis/2']"
  end
end
