class PassageSourceDocument < ApplicationRecord
  belongs_to :passage
  belongs_to :source_document
end
