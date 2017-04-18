class LearningStyle < ActiveRecord::Base
  validates_presence_of :campus, :ca, :ec, :ea, :or, :ca_ec, :ea_or, :style
end
