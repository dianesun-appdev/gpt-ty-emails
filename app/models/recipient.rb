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
  
end
