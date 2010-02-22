class Page < ActiveRecord::Base
  attr_accessible :title, :permalink, :content
  
  validates_uniqueness_of :permalink
end
