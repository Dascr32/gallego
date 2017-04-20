class Professor < ActiveRecord::Base
  validates_presence_of :age, :gender, :self_avaluation,
                        :times_teaching, :background, :skills_with_pc,
                        :exp_with_web_tech, :exp_with_web_sites, :category

  def to_a
    attributes.values
  end
end
