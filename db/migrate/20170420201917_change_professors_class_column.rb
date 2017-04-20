class ChangeProfessorsClassColumn < ActiveRecord::Migration[5.0]
  def change
    change_table :professors do |t|
      t.rename :class, :category
    end
  end
end
