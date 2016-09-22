class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions
  set :session_secret, "wat_1"
  set :views, Proc.new { File.join(root, "../views/") }

  use Rack::Flash

  get '/' do
    erb :index
  end
end
