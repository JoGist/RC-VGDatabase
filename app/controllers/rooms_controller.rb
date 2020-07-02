class RoomsController < ApplicationController

    def edit
        id = params[:id]
        if Room.exists?(:user => User.find(id).username,:user1 => User.find(session[:user_id]).username)
            redirect_to room_path(Room.where(:user => User.find(id).username,:user1 => User.find(session[:user_id]).username)[0].id)
        elsif Room.exists?(:user => User.find(session[:user_id]).username,:user1 => User.find(id).username)
            redirect_to room_path(Room.where(:user => User.find(session[:user_id]).username,:user1 => User.find(id).username)[0].id)
        else 
            Room.create(:user => User.find(id).username,:user1 => User.find(session[:user_id]).username)
            redirect_to room_path(Room.where(:user => User.find(id).username,:user1 => User.find(session[:user_id]).username)[0].id)
        end
    end

    def show 
        id = params[:id]
        @room = Room.find(id)
        @room_messages = RoomMessage.where(:room => @room)
    end

    def update
        id = params[:id]
        text = params[:text]
        @message= RoomMessage.new(:message => text)
        @message.room_id = Room.find(id).id
        @message.user_id = session[:user_id]
        @message.save!
        redirect_to room_path(id)
        #RoomChannel.broadcast_to @room, @room_message
    end
  end