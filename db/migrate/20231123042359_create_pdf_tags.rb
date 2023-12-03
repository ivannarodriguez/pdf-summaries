class CreatePdfTags < ActiveRecord::Migration[7.0]
  def change
    create_table :pdf_tags do |t|
      t.references :pdf, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
