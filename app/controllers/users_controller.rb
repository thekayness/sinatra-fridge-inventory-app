require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      user = current_user
      redirect "/user/#{user.slug}"
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
      redirect "/user/#{@user.slug}"
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      user = current_user
      redirect to "/user/#{user.slug}"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/user/#{@user.slug}"
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect to '/'
    end
  end

  get '/user/:user_slug' do
    if logged_in?
      @items = current_user.items
      erb :'/users/index'
    else
      redirect to '/login'
    end
  end

end
