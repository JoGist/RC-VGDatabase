class Room < ActiveRecord::Migration[5.2]
  def change
      create_table :rooms do |t|
      t.string :user1
      t.string :user
      t.timestamps
      end
  end
end
