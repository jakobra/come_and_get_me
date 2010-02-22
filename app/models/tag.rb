class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tracks, :through => :taggings
end
