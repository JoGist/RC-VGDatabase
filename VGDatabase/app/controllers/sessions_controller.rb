class SessionsController < ApplicationController
    skip_before_action :set_current_user
    require 'apicalypse'
    require 'rubygems'
    def apiRest
        id = params[:id]
        @games = Game.where(:title => id)
        render json: @games
    end
    def apiRest2
        key = params[:key]
        id = params[:id]
        username = params[:username]
        mail = params[:mail]
        if key=='123456789'
            if id.length!=0 && User.exists?(:id => id)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:id => id)[0]
                render json: @user
            elsif username!=nil && User.exists?(:username => username)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:username => username)[0]
                render json: @user
            elsif mail!=nil && User.exists?(:email => mail)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:email => mail)[0]
                render json: @user
            else
                render json: []
            end
        else
            render json: 401
        end
    end
    def apiRest3
        game_id = params[:game_id]
        user_id = params[:user_id]
        key = params[:key]
        if key=='123456789'
            if user_id!=nil && User.exists?(:id => user_id)
                @re1 = Review.where(:user_id => User.find(user_id).id)
                render json: @re1
            elsif game_id!=nil && Game.exists?(:id => game_id)
                @re2 = Review.where(:game_id => User.find(game_id).id)
                render json: @re2
            else
                render json: []
            end
        elsif key==''
            if game_id!=nil && Game.exists?(:id => game_id)
                @re2 = Review.where(:game_id => User.find(game_id).id)
                render json: @re2
            end
        else
            render json: 401
        end
    end
    def apiRest4
        user_id = params[:user_id]
        key = params[:key]
        if key=='123456789'
            if user_id!=nil && User.exists?(:id => user_id)
                @f1 = Friend.where(:user_id => User.find(user_id).id)
                render json: @f1
            else
                render json: []
            end
        else
            render json: 401
        end
    end
    def apiRest5
        user_id = params[:user_id]
        key = params[:key]
        if key=='123456789'
            if user_id!=nil && User.exists?(:id => user_id)
                @m1 = Store.where(:user_id => User.find(user_id).id)
                render json: @m1
            else
                render json: []
            end
        else
            render json: 401
        end
    end

def login
end
def signup
end
def signin
        name = params[:user][:name]
        password = params[:user][:password]
        name1 = params[:user][:name1]
        password1 = params[:user][:password1]
        if User.exists?(:email => name)         # Vede se esiste già la mail
            redirect_to signup_error_mail_path
        elsif name1 == 'admin'                  # Non può creare un nuovo admin
            redirect_to signup_error_username_path
        elsif User.exists?(:username => name1)  # Username già esistente
            redirect_to signup_error_username_path
        elsif password != password1             # Password non coincidono    
            redirect_to signup_error_password_path
        else                                    # Controlli a buon fine
            @users = User.create(:email => name, :password => password, :username => name1, :avatar => 'Avatars/avatar_0',:background => 'deafult.png', :social1 => '', :social2 => '', :social3 => '')
            redirect_to login_path
        end
end
def create
    name = params[:user][:name]
    username = params[:user][:name1]
    password = params[:user][:password]
    if User.exists?(User.where(:username => name))
        @users = User.where(:username => name)[0]
        if name == 'admin' && @users.username == name && @users.password == password
            session[:user_id]= @users.id
            redirect_to settings_path
        elsif @users.username == name && @users.password == password
            session[:user_id]=@users.id
            redirect_to homepage_path
        else
            redirect_to login_error_path
        end
    else
        redirect_to login_error_path
    end
end

def login_error
end

def signup_error_mail
end

def signup_error_username
end

def signup_error_password
end

def forgot_password
end

def forgot_password_error
end

def forgot_password_error_password
end

def change_password
    email = params[:user][:name]
    password = params[:user][:password]
    username = params[:user][:name1]
    password1 = params[:user][:password1]
    if (!User.exists?(:email => email) || !User.exists?(:username => username))
        redirect_to forgot_password_error_path
    elsif password != password1             # Password non coincidono    
        redirect_to forgot_password_error_password_path
    else                                    # Controlli a buon fine
        @user = User.where(:email => email)[0]
        @user.update_attributes!(params[:user].permit(:password))
        redirect_to login_path
    end
end

def homepageGuest
    @games = Game.all
end

def contactUsGuest
end

def searchGuestUser
end

def searchUserErrorGuest
end

def searchingGuestUser
    user = params[:username]
    if User.exists?(User.where(:username => user))
        @users = User.where(:username => user)[0].id
        redirect_to visit_profile_path(@users)
    else
        redirect_to search_user_error_guest_path
    end
end

def searchGuestGame
    @games = Game.all
end

    def searchResult
        @search = params[:search]
        genre = params[:game][:genre]
        if genre == 'Genre'
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @result = api.request
            @genre_requested = 0
            #render html: "#{@result}"

        elsif genre == 'Arcade'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request   
            @games = api.request 
            @result = []
            @genre_requested = 33
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(33)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'Adventure'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @games = api.request
            @result = []
            @genre_requested = 31
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(31)
                        @result.push(game)
                    end
                end
            end
        
        elsif genre == 'Fighting'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request   
            @games = api.request 
            @result = []
            @genre_requested = 4
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(4)
                        @result.push(game)
                    end
                end
            end
        
        elsif genre == 'Platform'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request   
            @games = api.request 
            @result = []
            @genre_requested = 8
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(8)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'Puzzle'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request   
            @games = api.request 
            @result = []
            @genre_requested = 9
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(9)
                        @result.push(game)
                    end
                end
            end
            
        elsif genre == 'Racing'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request   
            @games = api.request 
            @result = []
            @genre_requested = 10
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(10)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'RPG'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @games = api.request
            @result = []
            @genre_requested = 12
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(12)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'Shooter'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @games = api.request
            @result = []
            @genre_requested = 5
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(5)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'Simulator'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @games = api.request
            @result = []
            @genre_requested = 13
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(13)
                        @result.push(game)
                    end
                end
            end

        elsif genre == 'Sport'  
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms).search(@search).limit(12).request
            @games = api.request
            @result = []
            @genre_requested = 14
            @games.each do |game|
                if game.keys.include?('cover') && game.keys.include?('genres') && game.keys.include?('platforms')
                    if game.values[2].include?(14)
                        @result.push(game)
                    end
                end
            end
        end
    end
            

def destroy
    session.delete(:user_id)
    redirect_to login_path
end

end
