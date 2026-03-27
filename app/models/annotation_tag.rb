class AnnotationTag < ApplicationRecord
  belongs_to :annotation
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :annotation_id }
end
