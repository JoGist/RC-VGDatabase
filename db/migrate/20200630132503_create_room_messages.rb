class CreateRoomMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :room_messages do |t|
      t.references 'room'
      t.references 'user'
      t.text 'message'

      t.timestamps
    end
  end
end
