class CurriculumItem < ApplicationRecord
  belongs_to :curriculum, foreign_key: :curriculum_id
  belongs_to :passage

  validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :passage_id, uniqueness: { scope: :curriculum_id }

  default_scope { order(:position) }

  delegate :division, :scripture, to: :passage
  delegate :corpus, to: :scripture
end
