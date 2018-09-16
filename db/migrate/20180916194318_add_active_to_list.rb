class AddActiveToList < ActiveRecord::Migration[5.2]
  def change
    add_column :lists, :active, :boolean, default: true
  end
end
