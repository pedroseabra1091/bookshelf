class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :book, null: false, foreign_key: true, index: false
      t.references :user, null: false, foreign_key: true, index: false
      t.date :returned_on

      t.timestamps
    end
  end
end
