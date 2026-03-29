require "test_helper"

class Collections::PassagesControllerTest < ActionDispatch::IntegrationTest
  setup { sign_in_as(users(:scholar)) }

  test "create adds passage to collection" do
    collection = users(:scholar).collections.create!(name: "Test")
    assert_difference "CollectionPassage.count", 1 do
      post collections_passages_path(collection_id: collection.id, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "create is idempotent" do
    collection = users(:scholar).collections.create!(name: "Test")
    collection.collection_passages.create!(passage: passages(:genesis_one_one), position: 1)
    assert_no_difference "CollectionPassage.count" do
      post collections_passages_path(collection_id: collection.id, passage_id: passages(:genesis_one_one).id)
    end
  end

  test "destroy removes passage from collection" do
    collection = users(:scholar).collections.create!(name: "Test")
    collection.collection_passages.create!(passage: passages(:genesis_one_one), position: 1)
    assert_difference "CollectionPassage.count", -1 do
      delete collections_passage_path(id: passages(:genesis_one_one).id, collection_id: collection.id, passage_id: passages(:genesis_one_one).id)
    end
  end
end
