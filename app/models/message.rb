# == Schema Information
#
# Table name: messages
#
#  id               :integer          not null, primary key
#  discussion_topic :string
#  email_body       :string
#  length           :string
#  llm_prompt       :string
#  occasion         :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  recipient_id     :integer
#  sender_id        :integer
#
class Message < ApplicationRecord

  belongs_to :sender, required: true, class_name: "User", foreign_key: "sender_id", counter_cache: true
  belongs_to :recipient, class_name: "Recipient", foreign_key: "recipient_id", counter_cache: true

end
