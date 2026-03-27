class AddLemmaIndexToOriginalLanguageTokens < ActiveRecord::Migration[8.1]
  def change
    add_index :original_language_tokens, :lemma
  end
end
