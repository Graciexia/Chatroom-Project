class CreateRoom < ActiveRecord::Migration
 def change
      create_table :rooms do |t|
      t.integer :room, null: false, default: 1
      t.string :user, null: false
      t.string :messages
      t.timestamps null: false
    end
  end
end
