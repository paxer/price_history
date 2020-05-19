class CreatePriceCaptures < ActiveRecord::Migration[6.0]
  def change
    create_table :price_captures do |t|
      t.decimal :bid
      t.decimal :ask
      t.datetime :capture_time
      t.string :cryptocurrency_code
      t.string :currency_code

      t.timestamps
    end
  end
end
