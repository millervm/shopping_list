class AddDefaultValueToItemUrgent < ActiveRecord::Migration[5.2]
  def up
    change_column :items, :urgent, :boolean, default: false
  end
  
  def down
    change_column :items, :urgent, :boolean, default: nil
  end
end
