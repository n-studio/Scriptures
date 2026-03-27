class AddEditionTypeToTranslations < ActiveRecord::Migration[8.1]
  def change
    add_column :translations, :edition_type, :string
  end
end
