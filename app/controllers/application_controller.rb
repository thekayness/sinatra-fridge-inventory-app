class ApplicationController < Sinatra::Base

  configure do
    register Sinatra::ActiveRecordExtension
    enable :sessions
    set :session_secret, "wat_1"
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end
end
