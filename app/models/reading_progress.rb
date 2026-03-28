class ReadingProgress < ApplicationRecord
  belongs_to :user
  belongs_to :passage

  validates :read_at, presence: true
  validates :passage_id, uniqueness: { scope: :user_id }
end
