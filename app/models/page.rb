class Page < ActiveRecord::Base
  attr_accessible :title, :permalink, :content, :public
  
  validates_presence_of :permalink, :title, :content
  validates_uniqueness_of :permalink
end
