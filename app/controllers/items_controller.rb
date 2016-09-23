class ItemsController < ApplicationController

  get '/fridge/:item_slug/edit' do
    @item = Item.find_by_slug(params[:item_slug])
    if logged_in? && @item
      @item
      erb :'/items/edit_item'
    elsif logged_in?
      redirect to "user/#{current_user.slug}"
      #flash item not found
    else
      redirect to '/'
    end
  end

  get '/fridge/new_item' do
    if logged_in?
      @user = current_user
      erb :'/items/new_item'
    else
      redirect to '/'
    end
  end

  post '/user/:user_slug' do
    if logged_in? && !params[:name].empty?
      new_item = Item.create(:name =>  params[:name], :exp_date => params[:exp_date], :category => params[:category], :servings => params[:servings])
      current_user.items << new_item
      redirect to "/user/#{current_user.slug}"
    elsif logged_in?
      redirect to "fridge/new_item"
    else
      redirect to '/'
    end
  end

  patch '/fridge/:item_id' do
    item = Item.find(params[:item_id])
    if logged_in? && params[:check] || !params[:name].empty?
      if params[:name].empty? && params[:check][:name].empty?
        redirect to "fridge/#{item.slug}/edit"
      else
        item.update(name: params[:check][:name] ||= params[:name], exp_date: params[:check][:date] ||= params[:exp_date], category: params[:check][:category] ||= params[:category], servings: params[:check][:servings] ||= params[:servings] )
        item.save
        redirect to "/user/#{current_user.slug}"
      end
    elsif logged_in?
      redirect to "fridge/#{item.slug}/edit"
      #flash must enter value or keep the same
    else
      redirect to '/'
    end
  end

  delete '/fridge/:item_id/delete' do
    item = Item.find(params[:item_id])
    if logged_in?
      Item.destroy(item.id)
      redirect to "/user/#{current_user.slug}"
    else
      redirect to "/"
    end
  end

end
