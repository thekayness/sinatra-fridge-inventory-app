class UsersController < ActiveRecord::Base
  get '/users/:slug' do
      @user = User.find_by_slug(params[:slug])
      erb :'/users/show_user_tweets'
    end

  get '/signup' do
    if session[:user_id]
      redirect "/fridge/#{User.find(session[:user_id])}"
    else
      erb :'/users/create_user'
    end
  end

  post '/signup' do

    if !params[:username].empty? && !params[:email].empty?
      @user = User.new(username: params["username"], email: params["email"], password: params["password"])
    end
    if @user && @user.save
      session[:user_id] = @user.id
      redirect "/fridge/#{@user.username.slug}"
    else
      redirect '/signup'
    end
  end

  get '/fridge/:username_slug' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      @items = @user.items.all
      erb :'/users/show_user_items'
    else
      redirect to '/login'
    end
  end

  get '/login' do
    if session[:user_id]
      redirect to "/fridge/#{@user.username.slug}"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/fridge/#{@user.username.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if session[:user_id]
      session.clear
      redirect '/login'
    else
      redirect to '/'
    end
  end

end
