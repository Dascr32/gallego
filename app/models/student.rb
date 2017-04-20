class Student < ActiveRecord::Base
  validates_presence_of :gender, :campus, :gpa, :ca,
                        :ec, :ea, :or, :ca_ec, :ea_or, :style
end
