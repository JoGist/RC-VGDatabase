class AddReadToRoomMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :room_messages, :read, :string
  end
end
