class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.decimal :price, precision: 2

      t.timestamps
    end
  end
end
