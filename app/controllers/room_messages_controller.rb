class RoomMessagesController < ApplicationController
  before_action :load_entities

  def create
  end

  protected


  def load_entities
    @room = Room.find(params.dig(:room_message, :room_id))
  end
end
