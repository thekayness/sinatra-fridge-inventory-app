kay = User.create(:username "Kathleena", :email "howdy@lol.com", :password "whatup")
item1 = Item.create(:name "soy milk", :exp_date "10/5/2016", :category "Beverages", :servings 6)
item2 = Item.create(:name "cucumbers", :exp_date "9/21/2016", :category "Produce", :servings 3)

kay.items << item1
kay.items << item2
