class ItemsController < ApplicationController

  get '/fridge/:item_slug/edit' do
    @item = Item.find_by_slug(params[:item_slug])
    if logged_in? && @item
      @item
      erb :'/items/edit_item'
    elsif logged_in?
      redirect to "user/#{current_user.slug}"
      flash[:message] = "Item not found."
    else
      redirect to '/'
    end
  end

  get '/fridge/new_item' do
    if logged_in?
      @user = current_user
      erb :'/items/new_item'
    else
      flash[:message] = "You must be logged in to see this page."
      redirect to '/'
    end
  end

  post '/user/:user_slug' do
    if logged_in? && !params[:name].empty?
      new_item = Item.create(:name =>  params[:name], :exp_date => params[:exp_date], :category => params[:category], :servings => params[:servings])
      current_user.items << new_item
      flash[:message] = "#{new_item.name} successfully created!"
      redirect to "/user/#{current_user.slug}"
    elsif logged_in?
      flash[:message] = "An item must have at least a name."
      redirect to "fridge/new_item"
    else
      flash[:message] = "You must be logged in to see this page."
      redirect to '/'
    end
  end

  patch '/fridge/:item_id' do
    @item = Item.find(params[:item_id])
    if logged_in? &&!params[:name].empty?
      @item.update(name: params[:name], exp_date: params[:exp_date], category: params[:category], servings:  params[:servings] )
      @item.save
      flash[:message] = "#{@item.name} successfully edited!"
      redirect to "/user/#{current_user.slug}"
    elsif logged_in?
      flash[:message] = "An item must have at least a name."
      redirect to "fridge/#{@item.slug}/edit"
      #flash must enter value or keep the same
    else
      flash[:message] = "You must be logged in to see this page."
      redirect to '/'
    end
  end

  delete '/fridge/:item_id/delete' do
    item = Item.find(params[:item_id])
    if logged_in?
      Item.destroy(item.id)
      flash[:message] = "Item successfully deleted!"
      redirect to "/user/#{current_user.slug}"
    else
      flash[:message] = "You must be logged in to see this page."
      redirect to "/"
    end
  end

end
