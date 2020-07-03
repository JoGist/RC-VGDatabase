class RoomChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(8)
    stream_from "room_#{params[:room]}"
  end
end
