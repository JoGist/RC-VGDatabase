class RoomMessagesController < ApplicationController
  before_action :load_entities

  def create
    RoomChannel.broadcast_to @room, @room_message
  end

  protected


  def load_entities
    @room = Room.find params.dig(:room_message, :room_id)
  end
end
