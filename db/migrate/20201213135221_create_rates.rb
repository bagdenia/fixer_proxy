class CreateRates < ActiveRecord::Migration[6.1]
  def change
    create_table :rates do |t|
      t.string :base, null: false
      t.string :other, null: false
      t.date :date, null: false
      t.decimal :rate, null: false

      t.timestamps
    end

    add_index :rates, %i[base other date], unique: true
  end
end
