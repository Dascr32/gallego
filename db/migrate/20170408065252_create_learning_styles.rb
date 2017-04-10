class CreateLearningStyles < ActiveRecord::Migration[5.0]
  def change
    create_table :learning_styles do |t|
      t.string :campus
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
