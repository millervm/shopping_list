class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.boolean :complete
      t.boolean :urgent
      t.integer :list_id
      t.integer :user_id

      t.timestamps
    end
  end
end
