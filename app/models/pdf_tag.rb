# == Schema Information
#
# Table name: pdf_tags
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  pdf_id     :integer          not null
#  tag_id     :integer          not null
#
# Indexes
#
#  index_pdf_tags_on_pdf_id  (pdf_id)
#  index_pdf_tags_on_tag_id  (tag_id)
#
# Foreign Keys
#
#  pdf_id  (pdf_id => pdfs.id)
#  tag_id  (tag_id => tags.id)
#
class PdfTag < ApplicationRecord
  belongs_to :pdf
  belongs_to :tag
end
