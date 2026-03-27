class CollectionPassage < ApplicationRecord
  belongs_to :collection
  belongs_to :passage

  validates :passage_id, uniqueness: { scope: :collection_id }

  default_scope { order(:position) }
end
