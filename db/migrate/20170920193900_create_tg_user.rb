class CreateTgUser < ActiveRecord::Migration[5.1]
  def change
    create_table :tg_users do |t|
      t.string :telegram_id
      t.boolean :is_bot
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :language_code
    end

    add_index :tg_users, :telegram_id
  end
end
