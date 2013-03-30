class Tracksegment < ActiveRecord::Base
  belongs_to :track
  has_many :points, :dependent => :delete_all
  
  attr_accessible :points_attributes, :circle
  
  accepts_nested_attributes_for :points, :allow_destroy => true
  
  attr_accessor :circle
  
  after_save :set_finish_point
  
  private
  
  def set_finish_point
    if circle == "1"
      lp = points.first
      points.create(:longitude => lp.longitude, 
                    :latitude => lp.latitude, 
                    :elevation => lp.elevation)
    end
  end
  
end
