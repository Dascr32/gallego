class Professor < ActiveRecord::Base
  validates_presence_of :age, :gender, :self_avaluation,
                        :times_teaching, :background, :skills_with_pc,
                        :exp_with_web_tech, :exp_with_web_sites, :category

  def to_a(id_category: true)
    attrs = attributes.values
    unless id_category
      # Remove id & category values
      attrs.pop
      attrs.shift
    end
    attrs
  end
end
