# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  default_industry :string
#  email            :string
#  first_name       :string
#  messages_count   :integer
#  password_digest  :string
#  writing_sample   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class User < ApplicationRecord
  validates :email, :uniqueness => { :case_sensitive => false }
  validates :email, :presence => true
  has_secure_password
end
