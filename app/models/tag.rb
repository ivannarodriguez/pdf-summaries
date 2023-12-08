# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_tags_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Tag < ApplicationRecord
  validates(:name, {
    :presence => true,
  })
  validates(:color, {
    :presence => true,
  })
  belongs_to :user
  has_many :pdf_tags
  has_many :pdfs, through: :pdf_tags
end
