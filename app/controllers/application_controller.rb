class ApplicationController < Sinatra::Base

  configure do
    register Sinatra::ActiveRecordExtension
    enable :sessions
    set :session_secret, "wat_1"
    set :views, 'app/views'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/' do
    erb :index
  end
end
