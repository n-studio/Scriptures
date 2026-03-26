class Scripture < ApplicationRecord
  belongs_to :corpus
  has_many :divisions, dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: { scope: :corpus_id }

  default_scope { order(:position) }

  def to_param = slug
end
