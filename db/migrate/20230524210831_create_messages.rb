class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :email_body
      t.string :occasion
      t.string :discussion_topic
      t.integer :recipient_id
      t.string :llm_prompt
      t.integer :sender_id
      t.string :length
      t.string :recipient_name
      t.string :api_response

      t.timestamps
    end
  end
end
