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
        redirect_to collection_path
    end

    def destroy
        id = params[:id]
		@mygame = Store.find(id)
        @mygame.destroy
        redirect_to editCollection_path
    end

    def update
        id = params[:id]
        @mygame = Store.find(id)
        if @mygame.price==0
            condition = params[:store][:condition]
            price = params[:price]
            @mygame.update_attributes(:price => price, :condition => condition, :selling =>'true')
            redirect_to selling_path
        elsif @mygame.price!=0
            condition = params[:store][:condition]
            price = params[:price]
            @mygame.update_attributes(:price => price, :condition => condition)
            redirect_to selling_path
        end
    end

    def show
        id = params[:id]
        @mygame = Store.find(id)
        @mygame.update_attributes(:price => 0, :condition => '', :selling => 'false')
        redirect_to editSelling_path  
    end

    def edit
        @user = User.find(session[:user_id])
        @game = Game.find(params[:game_id])  
        @library = Store.find(Store.where(:user_id => @user,:game_id => params[:game_id])[0].id)
    end
end