class Tag < ApplicationRecord
  belongs_to :user
  has_many :annotation_tags, dependent: :destroy
  has_many :annotations, through: :annotation_tags

  validates :name, presence: true, uniqueness: { scope: :user_id }

  default_scope { order(:name) }
end
