class CreateItemsTable < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :exp_date
      t.string :category
      t.integer :servings
    end
  end
end
