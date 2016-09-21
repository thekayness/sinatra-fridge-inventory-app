require 'spec_helper'

describe 'User' do
  before do
    @user = User.create(:username => "test 123", :email => "test123@aol.com", :password => "test")

    @item =  Item.create(:name => "Tomato sauce", :exp_date => "9/9/1999")

    @user << @item
  end


  it 'can slug the username' do
    expect(@user.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("test 123")
  end

  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("test")).to eq(@user)

  end
end

describe "item" do

  it "can initialize a item" do
    expect(Item.new).to be_an_instance_of(Item)
  end

  it "can have a name" do
    expect(@item.name).to eq("Tomato sauce")
  end

  it "can have an expiration date" do
    expect(@item.exp_date).to eq("9/9/1999")
  end

  it "can have many users" do
    expect(UserItems.count).to eq(1)
  end

  it "can slugify its name" do

    expect(@item.slug).to eq("tomato-sauce")
  end

  describe "Class methods" do
    it "given the slug can find a item" do
      slug = "tomato-sauce"

      expect((Item.find_by_slug(slug)).name).to eq("Tomato sauce")
    end
  end
end
