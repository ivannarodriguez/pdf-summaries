class AddSavedToPdfs < ActiveRecord::Migration[7.0]
  def change
    add_column :pdfs, :saved, :boolean, default: false
  end
end
