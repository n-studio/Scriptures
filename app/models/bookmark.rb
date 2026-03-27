class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :passage

  validates :passage_id, uniqueness: { scope: :user_id }

  default_scope { order(created_at: :desc) }

  delegate :division, to: :passage
  delegate :scripture, to: :division
end
