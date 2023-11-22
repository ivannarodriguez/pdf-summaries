class CreatePdfs < ActiveRecord::Migration[7.0]
  def change
    create_table :pdfs do |t|
      t.string :title
      t.string :url
      t.string :summary

      t.timestamps
    end
  end
end
