class Network < ActiveRecord::Base
  validates_presence_of :reliability, :links, :capacity, :cost, :category
end
