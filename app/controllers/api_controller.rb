class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :set_current_user

    def apiRest #Gioco con quel titolo get
        key = params[:key]
        title = params[:title]
        if key=='123456789'
            @games = Game.where(:title => title)
            render json: @games
        else
            render json: 401
        end
    end
    def apiRest2 #Mostra utente tramite id/email/username get
        key = params[:key]
        id = params[:id]
        username = params[:username]
        email = params[:email]
        if key=='123456789'
            if id.length!=0 && User.exists?(:id => id)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:id => id)[0]
                render json: @user
            elsif username!=nil && User.exists?(:username => username)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:username => username)[0]
                render json: @user
            elsif email!=nil && User.exists?(:email => email)
                @user = User.select(:id,:username,:email,:google_token,:steam_token,:background,:avatar,:social1,:social2,:social3).where(:email => email)[0]
                render json: @user
            else
                render json: 404
            end
        else
            render json: 401
        end
    end
    def apiRest3 #Mostra le review dell'utente o di un gioco specifico tramite id get
        key = params[:key]
        game_id = params[:game_id]
        user_id = params[:user_id]
        if key=='123456789'
            if user_id!=nil && User.exists?(:id => user_id)
                @re1 = Review.where(:user_id => User.find(user_id).id)
                render json: @re1
            elsif game_id!=nil && Game.exists?(:id => game_id)
                @re2 = Review.where(:game_id => User.find(game_id).id)
                render json: @re2
            else
                render json: 404
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
    def apiRest4 #Amici di un dato utente get
        key = params[:key]
        user_id = params[:user_id]
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
    def apiRest5 #Collezione di un dato utente get
        key = params[:key]
        user_id = params[:user_id]
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

    def apiRest6 #Creazione di un utente post
        key = params[:key]
        username = params[:username]
        email = params[:email]
        password = params[:password]
        if key=='123456789'
            if !User.exists?(:username => username, :email => email)
                User.create(:username => username, :password => password, :email => email, :avatar => 'Avatars/avatar_0',:background => 'deafult.png', :social1 => '', :social2 => '', :social3 => '')
                render json: User.find(User.where(:username => username)[0].id)
            else
                render json: 'User already exists'
            end
        else
            render json: 401
        end
    end

    def apiRest7 #Eliminazione di un dato utente delete
        key = params[:key]
        username = params[:username]
        if key=='123456789'
            if User.exists?(:username => username)
                User.delete(User.where(:username => username)[0].id)
                render json: 200
            else
                render json: 404
            end
        else
            render json: 401
        end
    end

    def apiRest8 #Modifica di alcuni attributi del profilo di un utente put
        key = params[:key]
        usernameold = params[:usernameold]
        usernamenew = params[:usernamenew]
        password = params[:password]
        if key=='123456789'
            if User.exists?(:username => usernameold)
                User.where(:username => usernameold)[0].update_attributes!(:username => usernamenew, :password => password)
                render json: User.find(User.where(:username => usernamenew)[0].id)
            else
                render json: 404
            end
        else
            render json: 401
        end
    end

end
