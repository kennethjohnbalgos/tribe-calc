class CreateFormatBundles < ActiveRecord::Migration[6.1]
  def change
    create_table :format_bundles do |t|
      t.references :format, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price, precision: 8, scale: 2 

      t.timestamps
    end
  end
end
