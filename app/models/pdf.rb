# == Schema Information
#
# Table name: pdfs
#
#  id         :integer          not null, primary key
#  summary    :string
#  title      :string
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_pdfs_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Pdf < ApplicationRecord
  belongs_to :user
  has_many :pdf_tags
  has_many :tags, through: :pdf_tags
end
