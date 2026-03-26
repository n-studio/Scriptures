class Division < ApplicationRecord
  belongs_to :scripture
  belongs_to :parent, class_name: "Division", optional: true
  has_many :children, class_name: "Division", foreign_key: :parent_id, dependent: :destroy
  has_many :passages, dependent: :destroy

  default_scope { order(:position) }

  def display_name
    name || "Chapter #{number}"
  end
end
