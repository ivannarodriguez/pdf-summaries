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
#
class Pdf < ApplicationRecord
end
