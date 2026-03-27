require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "index lists bookmarks" do
    users(:scholar).bookmarks.create!(passage: passages(:genesis_one_one))
    get bookmarks_path
    assert_response :success
    assert_select "a[href*='genesis']"
  end

  test "create bookmarks a passage" do
    assert_difference "Bookmark.count", 1 do
      post bookmarks_path(passage_id: passages(:genesis_one_one).id)
    end
  end

  test "create is idempotent" do
    users(:scholar).bookmarks.create!(passage: passages(:genesis_one_one))
    assert_no_difference "Bookmark.count" do
      post bookmarks_path(passage_id: passages(:genesis_one_one).id)
    end
  end

  test "destroy removes bookmark" do
    bookmark = users(:scholar).bookmarks.create!(passage: passages(:genesis_one_one))
    assert_difference "Bookmark.count", -1 do
      delete bookmark_path(bookmark)
    end
  end

  test "requires authentication" do
    sign_out
    get bookmarks_path
    assert_redirected_to new_session_path
  end
end
