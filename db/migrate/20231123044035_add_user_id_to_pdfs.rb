class AddUserIdToPdfs < ActiveRecord::Migration[7.0]
  def change
    add_reference :pdfs, :user, null: false, foreign_key: true
  end
end
