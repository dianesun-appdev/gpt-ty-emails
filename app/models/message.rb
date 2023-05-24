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
end
