class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string  :gender
      t.string  :campus
      t.decimal :gpa
      t.integer :ca
      t.integer :ec
      t.integer :ea
      t.integer :or
      t.integer :ca_ec
      t.integer :ea_or
      t.string :style
    end
  end
end
