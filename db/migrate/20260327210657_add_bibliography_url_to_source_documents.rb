class AddBibliographyUrlToSourceDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :source_documents, :bibliography_url, :string
  end
end
