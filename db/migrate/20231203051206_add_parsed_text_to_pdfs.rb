class AddParsedTextToPdfs < ActiveRecord::Migration[7.0]
  def change
    add_column :pdfs, :parsed_text, :text
  end
end
