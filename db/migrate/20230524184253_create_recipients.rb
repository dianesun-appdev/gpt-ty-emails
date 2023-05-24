class CreateRecipients < ActiveRecord::Migration[6.0]
  def change
    create_table :recipients do |t|
      t.integer :company_id
      t.string :name
      t.string :email
      t.integer :messages_count

      t.timestamps
    end
  end
end
