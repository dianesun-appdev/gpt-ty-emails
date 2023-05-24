class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :first_name
      t.string :writing_sample
      t.string :default_industry
      t.integer :messages_count

      t.timestamps
    end
  end
end
