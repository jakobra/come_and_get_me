class Tracksegment < ActiveRecord::Base
  belongs_to :track
  has_many :points, :dependent => :delete_all
  
  accepts_nested_attributes_for :points, :allow_destroy => true
  
  attr_accessor :circle
  
  after_save :set_finish_point
  
  private
  
  def set_finish_point
    logger.info "Circle #{circle}"
    if circle == "1"
      lp = points.first
      points.create(:longitude => lp.longitude, 
                    :latitude => lp.latitude, 
                    :elevation => lp.elevation)
      logger.info "Finish point appended"
    end
  end
  
end
