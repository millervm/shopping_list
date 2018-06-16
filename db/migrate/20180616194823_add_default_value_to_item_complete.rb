class AddDefaultValueToItemComplete < ActiveRecord::Migration[5.2]
  def up
    change_column :items, :complete, :boolean, default: false
  end
  
  def down
    change_column :items, :complete, :boolean, default: nil
  end
end
