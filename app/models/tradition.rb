class Tradition < ApplicationRecord
  has_many :corpora, class_name: "Corpus", dependent: :destroy

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def to_param = slug
end
