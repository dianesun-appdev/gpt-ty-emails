# == Schema Information
#
# Table name: recipients
#
#  id             :integer          not null, primary key
#  email          :string
#  messages_count :integer
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  company_id     :integer
#
class Recipient < ApplicationRecord

  has_many  :messages, class_name: "Message", foreign_key: "recipient_id", dependent: :nullify
  belongs_to :company, class_name: "Company", foreign_key: "company_id"
  has_many :senders, through: :messages, source: :sender

end
