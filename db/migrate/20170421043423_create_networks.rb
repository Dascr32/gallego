class CreateNetworks < ActiveRecord::Migration[5.0]
  def change
    create_table :networks do |t|
      t.integer :reliability
      t.integer :links
      t.string  :capacity
      t.string  :cost
      t.string  :category
    end
  end
end
