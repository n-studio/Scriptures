class SourceDocument < ApplicationRecord
  belongs_to :corpus
  has_many :passage_source_documents, dependent: :destroy
  has_many :passages, through: :passage_source_documents

  validates :name, presence: true
  validates :abbreviation, presence: true
end
