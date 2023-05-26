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
  has_many :employees, class_name: "Recipient", foreign_key: "company_id", dependent: :nullify

  validates :name, :uniqueness => { :case_sensitive => false }
end
