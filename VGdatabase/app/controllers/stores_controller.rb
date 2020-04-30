class StoresController < ApplicationController
    skip_before_action :verify_authenticity_token
    def create
        game_id = params[:game_id]
        @games = Game.find(game_id)
        user_id = session[:user_id]
        @user = User.find(session[:user_id])
        @mylibrary = Store.new(:selling => 'false', :price => 0)
        @mylibrary.user_id = @user.id
        @mylibrary.game_id = @games.id
        @mylibrary.save!
        redirect_to myStore_path
    end

    def destroy
        id = params[:id]
		@mygame = Store.find(id)
        @mygame.destroy
        redirect_to editStore_path
    end

    def update
        id = params[:id]
        @mygame = Store.find(id)
        if @mygame.selling == "false"
            @mygame.update_attributes!(:selling => "true")
            redirect_to selling_path
        else
            @mygame.update_attributes!(:selling => "false")   
            redirect_to selling_path
        end
    end
end