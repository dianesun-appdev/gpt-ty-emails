# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  industry   :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Company < ApplicationRecord
end
