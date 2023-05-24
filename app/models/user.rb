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

  has_many  :messages, class_name: "Message", foreign_key: "sender_id", dependent: :destroy
  has_many :recipients, through: :messages, source: :recipient

end
