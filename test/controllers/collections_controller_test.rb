require "test_helper"

class CollectionsControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "index lists collections" do
    users(:scholar).collections.create!(name: "Flood narratives")
    get collections_path
    assert_response :success
    assert_select "div", /Flood narratives/
  end

  test "create makes a new collection" do
    assert_difference "Collection.count", 1 do
      post collections_path, params: { collection: { name: "Test" } }
    end
  end

  test "show renders public collection without auth" do
    sign_out
    collection = users(:scholar).collections.create!(name: "Public", public: true)
    get collection_path(collection)
    assert_response :success
  end

  test "show rejects private collection without auth" do
    sign_out
    collection = users(:scholar).collections.create!(name: "Private", public: false)
    get collection_path(collection)
    assert_redirected_to root_path
  end

  test "add_passage adds to collection" do
    collection = users(:scholar).collections.create!(name: "Test")
    assert_difference "CollectionPassage.count", 1 do
      post collections_passages_path(collection_id: collection.id, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "remove_passage removes from collection" do
    collection = users(:scholar).collections.create!(name: "Test")
    collection.collection_passages.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "CollectionPassage.count", -1 do
      delete collections_passage_path(id: passages(:genesis_one_one).id, collection_id: collection.id, passage_id: passages(:genesis_one_one).id)
    end
  end
end
