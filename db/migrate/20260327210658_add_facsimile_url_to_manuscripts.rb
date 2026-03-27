class AddFacsimileUrlToManuscripts < ActiveRecord::Migration[8.1]
  def change
    add_column :manuscripts, :facsimile_url, :string
  end
end
