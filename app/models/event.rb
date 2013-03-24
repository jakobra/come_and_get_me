class Event < ActiveRecord::Base
  attr_accessible :name, :description
  has_many :races
  
  validates_presence_of :name
end
