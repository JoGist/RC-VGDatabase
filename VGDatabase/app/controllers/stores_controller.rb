class StoresController < ApplicationController
    skip_before_action :verify_authenticity_token
    require 'apicalypse'
    require 'rubygems'
    def create
        game_id = params[:game_id]
        user_id = session[:user_id]
        if Game.exists?(:id => game_id)
            @games = Game.find(game_id)
            @user = User.find(session[:user_id])
            @mylibrary = Store.new(:selling => 'false', :price => 0)
            @mylibrary.user_id = @user.id
            @mylibrary.game_id = @games.id
            @mylibrary.save!
            redirect_to collection_path
        else  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms,:release_dates,:involved_companies).where(:id => game_id).request
            games = api.request[0]
            
            api_endpoint = 'https://api-v3.igdb.com/covers'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            cover = api.fields(:url).where(:id => games.values[1]).request[0].values[1]
            split = cover.split('thumb')[0]+'cover_big'+cover.split('thumb')[1]
  
            api_endpoint = 'https://api-v3.igdb.com/genres'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            genres = api.fields(:name).where(:id => games.values[2][0]).request[0].values[1]
            
            api_endpoint = 'https://api-v3.igdb.com/platforms'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            platform = api.fields(:name).where(:id => games.values[5][0]).request[0].values[1]

            api_endpoint = 'https://api-v3.igdb.com/release_dates'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            date = api.fields(:human).where(:game => games.values[0] , :platform => games.values[5][0]).request[0].values[1]

            api_endpoint = 'https://api-v3.igdb.com/involved_companies'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:company).where(:id => games.values[3][0]).limit(1).request
            involved_companies = api.request[0].values[1]

            api_endpoint = 'https://api-v3.igdb.com/companies'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:name).where(:id => involved_companies).limit(1).request
            companies = api.request[0].values[1]
            
            Game.create(:serial => game_id, :platform => platform, :genre => genres, :cover => split, :title => games.values[4], :release_date => date, :developer => companies)
            @games = Game.where(:serial => game_id)[0].id
            @user = User.find(session[:user_id])
            @mylibrary = Store.new(:selling => 'false', :price => 0)
            @mylibrary.user_id = @user.id
            @mylibrary.game_id = @games
            @mylibrary.save!
            redirect_to collection_path
        end
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
            @mygame.update_attributes(:price => price, :condition => condition, :selling => 'true')
            redirect_to selling_path
        elsif @mygame.price!=0
            condition = params[:store][:condition]
            price = params[:price]
            @mygame.update_attributes(:price => price, :condition => condition)
            redirect_to selling_path
        end
    end

    def edit
        @user = User.find(session[:user_id])
        @game = Game.find(params[:game_id])  
        @library = Store.find(Store.where(:user_id => @user,:game_id => params[:game_id])[0].id)
    end

    def show
        id = params[:id]
        @mygame = Store.find(id)
        @mygame.update_attributes(:price => 0, :condition => '', :selling => 'false')
        redirect_to editSelling_path  
    end
end