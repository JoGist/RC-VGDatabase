![logo/logo-normal.png](logo/logo-normal.png)
**VGDatabase (VGDB)** is a platform designed and built for gamers by gamers.

The site consists of a video game collection / sale platform. For each game you can view different information such as genre, developer, release date, score and reviews written by other users, and an additional external link for purchase on Amazon. Each game can be added to an user collection and possibly sell it, specifying its condition and price. The platform also offers a search function for games by title or genre, and a search for users. There is also a real time chat between users, to get in touch with them. The site is updated periodically, always showing the most popular games on the homepage at the moment. Each registered user therefore owns his own collection of owned games, games for sale and a list of friends (and a sub-list of favorite friends). Enjoy!

**The site is now live, [check it out](https://vgdatabase-rc.herokuapp.com/)!**

[Project overview (slides)](https://docs.google.com/presentation/d/e/2PACX-1vSeA_ezsfpQZcQRt0905mgQuVz5gjKw_SDKSvPaoy1c3JJOdPxcRv91MF2_Fw84KIYaAOXsirQWwcrZ/pub?start=true&loop=false&delayms=30000)

## Authors

*   **Giovanni Roma** - roma.1808340@studenti.uniroma1.it - [GitHub](https://github.com/JoGist) - [LinkedIn](https://www.linkedin.com/in/giovanni-roma-a95a32127/)
*   **Marco Musciaglia** - musciaglia.1816864@studenti.uniroma1.it - [GitHub](https://github.com/loldlink)
*   **Gianmarco Montillo** - montillo.1801402@studenti.uniroma1.it - [GitHub](https://github.com/gianmarcomontillo) - [LinkedIn](https://www.linkedin.com/in/gianmarco-montillo-1349371ab/)


## Technologies used
*   [Ruby/Rails](https://www.ruby-lang.org/) - for the base server and infrastructure
*   [Google Maps API](https://cloud.google.com/maps-platform) - for the map which show where each game is sold
*   [Google OAuth](https://support.google.com/cloud/answer/6158849?hl=en) - for autenticating with Google into the site
*   [Steam OAuth](https://partner.steamgames.com/doc/webapi_overview/oauth) - for autenticating with Steam into the site
*   [IGDB API](https://www.igdb.com/api) - for retreiving all games  information and cover art
*   [Redis-server](https://redis.io/) - to establish the action cable and manage the WebSockets across chatrooms
*   [PostgreSQL](https://www.postgresql.org/) - relational database in which we save all data
*   [Heroku](https://www.heroku.com/) - application hosting
*   [Swagger](https://swagger.io/) - REST API documentation


## Dependencies
In order to build and run the Rails server in your machine, you must have already installed and configured:
*   _Ruby 2.4_
*   _Rails 6_
*   _Bundler 2_
*   _Redis server (any version)_
*   _Postgres 9 or above_
*   _JavaScript (any version)_


## Rails app setup

In order to successfully run the project, you have to obtain a valid API key on these services:
* IGDB - https://www.igdb.com/api
* Google - https://support.google.com/cloud/answer/6158849?hl=en
* Steam - https://steamcommunity.com/dev/apikey
* Google Maps API on the [Google Cloud Platform](https://cloud.google.com/maps-platform/), making sure to also enable all of these API's: 
  *  Geocoding
  *  Maps Embed
  *  Maps JavaScript
  *  Places


To build and run the Rails app, go into the root folder of the repo and run the following commands:

* Build and install all required Gems included in Gemfile:
  ```sh
  Bundle install
  ```
  
* Initialize Figaro gem, to store securely store your OAuth credentials: 
  ```sh
  figaro install
  ```
  
* To show your secret key, copy it as you will use it later:
  ```sh
  rake secret
  ```

* To enter your OAuth credentials and API keys, open the file /config/application.yml created with 'Figaro install', and append at the end of file as following:
  ```sh
  STEAM_WEB_API_KEY: '[your-steam-api-key-here]'
  SECRET_TOKEN: '[your-rake-secret-key-here]'

  GOOGLE_CLIENT_ID: '[your-google-client-id-here].apps.googleusercontent.com'
  GOOGLE_CLIENT_SECRET: '[your-google-api-key-here]'
  ```

* Insert your IGDB API key in the credentials file with:
  ```sh
  EDITOR='[any-IDE-here] --wait' rails credentials:edit
  ```
  And append at the end of the file that opens up the following code:
  ```sh
  maps:
    igdb: '[your-igdb-api-key-here]'
  ```

* Edit in [config/database.yml](config/database.yml) the username and password with the one you have set in your local machine.

* Ensure that the Postgres service is started:
  ```sh
  sudo service postgresql start
  ```
  
* Initialize the db:
  ```sh
  rake db:reset
  ```
 
* Execute database migrations:
  ```sh
  rake db:migrate
  ```
  
## Rails app usage

After the first setup, execute these commmands to start the server and deploy the application:

* Start Redis server:
  ```sh
  redis-server
  ```
  
* Start the rails server:
  ```sh
  rails server
  ```
  
* Then simply go on this page with your browser of choice and you're done!
  ```sh
  localhost:3000
  ```
  
  
## REST API
This Rails server also provides some REST API method, the documentation can be found here. For some methods, an API KEY is needed in order to increase security and prevent. For this project, the API KEY is a proof-of-concept, in the future it will be fully implemented with a request form and a key generation method. Any method listed here is fully functional and implemented, and in the future we'll plan to add every other API method, in order to be able to create other client or apps that can work and can be integrated with the site. The default key is '123456789'.

### [API DOCUMENTATION](https://app.swaggerhub.com/apis-docs/JoGist/VGDatabase/1.1.0)

*   Search game by title
*   Search user by user_id, user_email, user_username
*   Search review of specific user or game by user_id or game_id
*   Search user friends by user_id
*   Search user's game collection by user_id
*   New user registration
*   Delete user
*   Edit user attributes


## RSpec testing

This project also includes four test cases to test the main functions of the site. The test are:

1. Test login of an user
2. Add a friend to an user
3. Delete an user by admin
4. Delete a review by admin

* To launch them all at once, run:
  ```sh
  bundle exec rspec ./spec/*_spec.rb
  ```
  
  * To launch them individually, run:
  ```sh
  bundle exec rspec ./spec/1_addUser_spec.rb
  bundle exec rspec ./spec/2_addFriend_spec.rb
  bundle exec rspec ./spec/3_adminDeleteUser_spec.rb
  bundle exec rspec ./spec/4_adminDeleteReview_spec.rb
  ```

### Other useful command
* Run the integrated Rails console
  ```sh
  rails console
  ```

* View all the routes created in the project
  ```sh
  rails routes
  ```

* Drop and recreate the schema and the tables
  ```sh
  rake db:reset
  ```

* Execute database table migrations that are pending
  ```sh
  rake db:migrate
  ```
 
### Known issues
Unbfortunately, because the site is still under development and always expanding, there are current things that didn't work as we expected. Those are the currently known issues, feel free to report any other issue, feature or suggestion in the Issue tab.

*   Sometimes when logging in with Google or Steam, the site will redirect you to an error page instead of homepage, just close the pop-up and you will be redirected
