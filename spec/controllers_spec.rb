require 'spec_helper'
require 'pry'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome to FridgeIt")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end

    it 'signup directs user to their fridge index' do
      user = User.create(:username "skittles123", :email "skittles@aol.com", :password "rainbows")
      post '/signup', params
      expect(last_response.location).to include("/fridge/#{user.slug}")
    end

    it 'does not let a user sign up without a username' do
      params = {
        :username => "",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without an email' do
      params = {
        :username => "skittles123",
        :email => "",
        :password => "rainbows"
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a user sign up without a password' do
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => ""
      }
      post '/signup', params
      expect(last_response.location).to include('/signup')
    end

    it 'does not let a logged in user view the signup page' do
      user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
      params = {
        :username => "skittles123",
        :email => "skittles@aol.com",
        :password => "rainbows"
      }
      post '/signup', params
      session = {}
      session[:id] = user.id
      get '/signup'
      expect(last_response.location).to include("/fridge/#{user.slug}")
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the fridge index after login' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Welcome,#{user.username}")
    end

    it 'does not let user view login page if already logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      session = {}
      session[:id] = user.id
      get '/login'
      expect(last_response.location).to include("/fridge/#{user.slug}")
    end
  end

  describe "logout" do
    it "lets a user logout if they are already logged in" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

      params = {
        :username => "becky567",
        :password => "kittens"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")

    end
    it 'does not let a user logout if not logged in' do

      get '/logout'
      expect(last_response.location).to include("/")
    end

    it 'does not load user fridge page if user not logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      get "/fridge/#{user.slug}"
      expect(last_response.location).to include("/login")
    end

    it 'does load user fridge page if user is logged in' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


      visit '/login'

      fill_in(:username, :with => "becky567")
      fill_in(:password, :with => "kittens")
      click_button 'submit'
      expect(page.current_path).to eq("/fridge/#{user.slug}")
    end
  end

  describe 'user fridge page' do
    it 'shows all a single users fridge items' do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      item1 = Item.create(:name => "Cheese")
      item2 = Item.create(:name => "Watermelon")
      item1.user_ids << user.id
      item2.user_ids << user.id
      get "/fridge/#{user.slug}"
      expect(last_response.body).to include("Cheese")
      expect(last_response.body).to include("Watermelon")
    end

    it "has a link to create new item" do
      user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
      get "/fridge/#{user.slug}"
      expect(last_response.body).to include("<a href='/fridge/new_item'")

    #"has links to edit and delete each item"
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new item form if logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/fridge/new_item"        expect(page.status_code).to eq(200)

      end

      it 'lets user create an item if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/fridge/new_item'
        fill_in(:name, :with => "Yogurt")
        click_button 'submit'

        user = User.find_by(:username => "becky567")
        item = Item.find_by(:name => "Yogurt")
        expect(item).to be_instance_of(Item)
        expect(item.user_ids).to include(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let a user create an item with no name' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'

        visit '/fridge/new_item'

        fill_in(:name, :with => "")
        click_button 'submit'

        expect(Item.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/fridge/new_item")

      end
    end

    context 'logged out' do
      it 'does not let user view new item form if not logged in' do
        get '/fridge/new_item'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'edit action' do
    context "logged in" do
      it 'lets a user view item edit form if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        item = Item.create(:name => "Butter")
        item.user_items << user.id
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/fridge/#{item.slug}/edit"
        expect(page.status_code).to eq(200)
        expect(page.body).to include(item.name)
      end

      it 'lets a user edit their own item if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        item = Item.create(:name => "Eggs")
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/fridge/#{user.slug}/#{item.slug}/edit"

        fill_in(:name, :with => "Large eggs")

        click_button 'submit'
        expect(Item.find_by(:name => "Large eggs")).to be_instance_of(Item)
        expect(Item.find_by(:name => "Eggs")).to eq(nil)

        expect(page.status_code).to eq(200)
      end

      it 'does not let a user edit an item with no name' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        item = Item.create(:name => "Salami")
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "/fridge/#{user.slug}/#{item.slug}/edit"

        fill_in(:content, :with => "")

        click_button 'submit'
        expect(Item.find_by(:name => "Mangos")).to be(nil)
        expect(page.current_path).to eq("/fridge/#{user.slug}/#{item.slug}/edit")

      end
    end

    context "logged out" do
      it 'does not load let user view item edit form if not logged in' do
        get "/fridge/#{user.slug}/#{item.slug}/edit"
        expect(last_response.location).to include("/login")
      end
    end

  end

  describe 'delete action' do
    context "logged in" do
      it 'lets a user delete their own item if they are logged in' do
        user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
        item = Item.create(:name => "Celery")
        user.items << item
        visit '/login'

        fill_in(:username, :with => "becky567")
        fill_in(:password, :with => "kittens")
        click_button 'submit'
        visit "fridge/#{user.slug}"
        click_button "Delete Item"
        expect(page.status_code).to eq(200)
        expect(Item.find_by(:name => "Celery")).to eq(nil)
      end
    end
  end


end
