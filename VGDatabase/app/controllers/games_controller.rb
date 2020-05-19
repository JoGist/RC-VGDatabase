class GamesController < ApplicationController
skip_before_action :set_current_user
skip_before_action :verify_authenticity_token
    require 'apicalypse'
    require 'rubygems'
    require 'geocoder'
    def homepage
        @user = User.find(session[:user_id])
        game = Game.all
        @library = Store.where(:user_id => @user.id)
        if game.length==0
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms,:release_dates,:involved_companies,:popularity).where('popularity > 420').request
            @games = api.request
            @games.each do |games|
                if games.keys.include?('cover') && games.keys.include?('genres') && games.keys.include?('platforms') && games.keys.include?('popularity')
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

                    Game.create(:serial => games.values[0], :platform => platform, :genre => genres, :cover => split, :title => games.values[4], :release_date => date, :developer => companies)
                    end
                end
                @games = Game.order('games.title ASC').all
            else
                @games = Game.order('games.title ASC').all
            end
        end

    def collection
        @library = Store.all
        @user = User.find(session[:user_id])
    end

    def selling
        @library = Store.where(:selling => "true")
        @user = User.find(session[:user_id])
    end

    def collectionEdit
        @mylibrary = Store.all
        @user = User.find(session[:user_id])
    end

    def editSelling
        @mylibrary = Store.where(:selling => "true")
        @user = User.find(session[:user_id])
    end

    def search
    end

    def friends
        @user = User.find(session[:user_id])
        @friends = Friend.where(:user_id => @user.id, :favorite => 'true')
        @friends1 = Friend.where(:user_id => @user.id, :favorite => 'false')
    end

    def myProfile
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id,:favorite => 'true')
        @friends1 = Friend.where(:user_id => @user.id,:favorite => 'false')
    end

    def editProfile
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editProfileOauth
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editingProfileOauth
        username = params[:user][:name]
        email = params[:user][:email]
        newp = params[:user][:newp]
        newp1 = params[:user][:newp1]
        location = params[:user][:location]
        @user = User.find(session[:user_id])
        if username.length==0 && email.length==0 && newp.length==0 && newp1.length==0 && location.length==0
            redirect_to editProfileOauth_error_path
        elsif username.length!=0 && email.length!=0 && newp.length!=0 && newp==newp1 && location.length!=0
            if Geocoder.search(location) != []
                lat = Geocoder.search(location).last.latitude
                lng = Geocoder.search(location).last.longitude
                @user.update_attributes!(:username => username, :email => email, :password => newp, :location => location,:latitude => lat, :longitude => lng)
                redirect_to editProfileOauth_success_path
            else                
                redirect_to editProfileOauth_error_path  
            end
        else
            redirect_to editProfileOauth_error_path
        end
    end

    def editProfileOauth_error
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editProfileOauth_success
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def removeOauthGoogle
        @user = User.find(session[:user_id])
        @user.update_attributes!(:google_token => nil, :google_username => nil)
        redirect_to editProfile_path
    end

    def removeOauthSteam
        @user = User.find(session[:user_id])
        @user.update_attributes!(:steam_token => nil, :steam_username => nil)
        redirect_to editProfile_path
    end

    def editAvatar
        @avatar = Avatar.all
    end

    def editingAvatar
        @user = User.find(session[:user_id])
        @user = User.find(session[:user_id])
        avatar = params[:avatar]
        @user.update_attributes!(:avatar => avatar)
        redirect_to myProfile_path
    end

    def editingProfile
        username = params[:user][:name]
        email = params[:user][:email]
        oldp = params[:user][:oldp]
        newp = params[:user][:newp]
        newp1 = params[:user][:newp1]
        back = params[:user][:background]
        location = params[:user][:location]
        social1 = params[:user][:social1]
        social2 = params[:user][:social2]
        social3 = params[:user][:social3]
        @user = User.find(session[:user_id])
        if username.length!=0 && email.length!=0 && newp.length!=0 && newp==newp1 && oldp==@user.password && location.length!=0 && back.length!=0
            if Geocoder.search(location) != []
                lat = Geocoder.search(location).last.latitude
                lng = Geocoder.search(location).last.longitude
                @user.update_attributes!(:latitude => lat, :longitude => lng, :password => newp, :username => username, :email => email, :background => back, :location => location, :social1 => social1, :social2 => social2, :social3 => social3)
                redirect_to editProfile_success_path
            else 
                redirect_to editProfile_error_path  
            end
        elsif username.length!=0 && email.length!=0 && oldp.length==0 && location.length!=0 && back.length!=0
            if Geocoder.search(location) != []
                lat = Geocoder.search(location).last.latitude
                lng = Geocoder.search(location).last.longitude
                @user.update_attributes!(:latitude => lat, :longitude => lng, :username => username, :email => email, :background => back, :location => location, :social1 => social1, :social2 => social2, :social3 => social3)
                redirect_to editProfile_success_path  
            else 
                redirect_to editProfile_error_path  
            end                       
        else
            redirect_to editProfile_error_path
        end
    end

    def editProfile_success
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def editProfile_error
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def deleteUserConfirmation
        @user = User.find(session[:user_id])
        @review = Review.where(:user_id => @user)
        @friends = Friend.where(:user_id => @user.id)
    end

    def show
        id = params[:id]
        @games = Game.find(id)
        @library = Store.where(:user_id => session[:user_id])
        @user = session[:user_id]
        @aux = Review.where(:game_id => @games)
        @aux = @aux.where('user_id != ?', @user)
        @review = Review.where(:game_id => @games, :user_id => @user)
        api_endpoint = 'https://api-v3.igdb.com/games'
        request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
        api = Apicalypse.new(api_endpoint, request_headers)
        api.fields(:summary).where(:id => @games.serial).request
        @plot = api.request[0].values[1]
        @users = Store.where(:selling => 'true', :condition => 'New', :game_id => id)
        @users1 = Store.where(:selling => 'true', :condition => 'Used', :game_id => id)
        @hash = Gmaps4rails.build_markers(@users) do |user, marker|
            if user.user_id==@user
                marker.lat User.find(user.user_id).latitude
                marker.lng User.find(user.user_id).longitude
                marker.json({:id => user.id })
                marker.infowindow "You"+" sells it for "+user.price.to_s+"€"#+render_to_string(:partial => "/users/infowindow", :locals => { :object => user})
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker.png"),
                "width" =>  20,
                "height" => 30})
            else
                marker.lat User.find(user.user_id).latitude
                marker.lng User.find(user.user_id).longitude
                marker.json({:id => user.id })
                marker.infowindow User.find(user.user_id).username+" sells it for "+user.price.to_s+"€"#+render_to_string(:partial => "/users/infowindow", :locals => { :object => user})
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker.png"),
                "width" =>  20,
                "height" => 30})
            end
        end
        @hash1 = Gmaps4rails.build_markers(@users1) do |user, marker|
            if user.user_id==@user
                marker.lat User.find(user.user_id).latitude
                marker.lng User.find(user.user_id).longitude
                marker.infowindow "you"+" sells it for "+user.price.to_s+"€"
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker_alt.png"),
                "width" =>  20,
                "height" => 30})
            else
                marker.lat User.find(user.user_id).latitude
                marker.lng User.find(user.user_id).longitude
                marker.json({:id => user.id })
                marker.infowindow User.find(user.user_id).username+" sells it for "+user.price.to_s+"€"#+render_to_string(:partial => "/users/infowindow", :locals => { :object => user})
                marker.picture({
                "url" => ActionController::Base.helpers.asset_path("marker_alt.png"),
                "width" =>  20,
                "height" => 30})
            end
        end
    end

    def gmaps4rails_marker_picture
        {
          "rich_marker" =>  "<div class='my-marker'>It works!<img height='30' width='30' src='http://farm4.static.flickr.com/3212/3012579547_097e27ced9_m.jpg'/></div>"
        }
      end

    def revert 
        @user = User.find(session[:user_id])
        @user.update_attributes!(:background => "default.png")
        redirect_to editProfile_success_path  
    end

    def contactUs
        @user = User.find(session[:user_id])
    end

    def deleteUser
        name = session[:user_id]
        @friends = Friend.where(:user_id => name)
        @friends.each do |friend|
            friend.delete
        end
        @friends1 = Friend.where(:friend_id => name)
        @friends1.each do |friend|
            friend.delete
        end
        @review = Review.where(:user_id => name)
        @review.each do |review|
            review.delete
        end
        @library = Store.where(:user_id => name)
        @library.each do |library|
            library.delete
        end
        session.delete(:user_id)
        User.delete(name)
        redirect_to login_path
    end



    def searchUser
        @user = User.find(session[:user_id])
    end

    def searchUserError
        @user = User.find(session[:user_id])
    end

    def searchingUser
        user = params[:username]
        if User.exists?(User.where(:username => user))
            if user==User.find(session[:user_id]).username
                @users = User.where(:username => user)[0].id
                redirect_to myProfile_path
            else
                @users = User.where(:username => user)[0].id
                redirect_to visit_profile_path(@users)
            end
        else
            redirect_to searchUserError_path
        end
    end

    def searchGame
        @games = Game.all
        @user = User.find(session[:user_id])
    end


    def searchResult
        @search = params[:search]
        genre = params[:game][:genre]
        @user = User.find(session[:user_id])
        if genre == 'Genre'
            api_endpoint = 'https://api-v3.igdb.com/games'
            request_headers = { headers: { 'user-key' => Rails.application.credentials.maps[:igdb] } }
            api = Apicalypse.new(api_endpoint, request_headers)
            api.fields(:cover,:genres,:name,:platforms,:involved_companies).search(@search).limit(12).request
            @result = api.request
            @genre_requested = 0

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


#admin

    def settings
        @users = User.all
        @reviews = Review.all
        @libraries = Store.all
    end

    def deleteReviewsGame
    end

    def deleteReviewsGame_success
    end

    def deleteReviewsGame_error
    end

    def deletingReviewsGame
        game1 = params[:game][:title]
        if(Game.exists?(:title => game1))
            @game = Game.where(:title => game1)[0].id
            if(Review.exists?(:game_id => @game))
                @review = Review.where(:game_id => @game)
                @review.each do |review|
                    Review.delete(review.id)
                end
                redirect_to deleteReviewsGame_success_path
            else
                redirect_to deleteReviewsGame_error_path
            end
        else
            redirect_to deleteReviewsGame_error_path
        end
    end

    def deleteReviewsUser
    end

    def deleteReviewsUser_success
    end

    def deleteReviewsUser_error
    end

    def deletingReviewsUser
        user1 = params[:user][:name]
        game1 = params[:game][:title]
        if(User.exists?(:username => user1) && Game.exists?(:title => game1))
            @user = User.where(:username => user1)[0].id
            @game = Game.where(:title => game1)[0].id
            if(Review.exists?(:user_id => @user,:game_id => @game))
                @review = Review.where(:user_id => @user,:game_id => @game)[0].id
                Review.delete(@review)
                redirect_to deleteReviewsUser_success_path
            else
                redirect_to deleteReviewsUser_error_path
            end
        else
            redirect_to deleteReviewsUser_error_path
        end
    end

    def deletingUser
    end

    def deletingAdminUser
        name = params[:user][:name]
        if name == 'admin'
            redirect_to deletingUser_error_path
        else
            if User.exists?(User.where(:username => name))
                @user = User.where(:username => name)[0].id
                @friends = Friend.where(:user_id => @user)
                @friends.each do |friend|
                    friend.delete
                end
                @friends1 = Friend.where(:friend_id => @user)
                @friends1.each do |friend|
                    friend.delete
                end
                @review = Review.where(:user_id => @user)
                @review.each do |review|
                    review.delete
                end
                @library = Store.where(:user_id => @user)
                @library.each do |library|
                    library.delete
                end
                User.delete(@user)
                redirect_to deletingUser_succes_path
            else
                redirect_to deletingUser_error_path
            end
        end
    end

    def deletingUser_success
    end

    def deletingUser_error
    end

    def deleteGameLibrary
    end

    def deletingGameLibrary
        game = params[:game][:title]
        user = params[:user][:name]
        if User.exists?(:username => user) && Game.exists?(:title => game)
            game_id = Game.where(:title => game)[0].id
            user_id = User.where(:username => user)[0].id
            if Store.exists?(:game_id => game_id,:user_id => user_id)
                library = Store.where(:game_id => game_id, :user_id => user_id)[0].id
                Store.delete(library)
                redirect_to deleteGameLibrary_success_path
            else
                redirect_to deleteGameLibrary_error_path
            end
        else
            redirect_to deleteGameLibrary_error_path
        end
    end

    def deleteGameLibrary_success
    end

    def deleteGameLibrary_error
    end

end
