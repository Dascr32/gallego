class CreateProfessors < ActiveRecord::Migration[5.0]
  def change
    create_table :professors do |t|
      t.integer :age
      t.string  :gender
      t.string  :self_avaluation
      t.integer :times_teaching
      t.string  :background
      t.string  :skills_with_pc
      t.string  :exp_with_web_tech
      t.string  :exp_with_web_sites
      t.string  :class
    end
  end
end
