class RemovePriceFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :price, :decimal
  end
end
