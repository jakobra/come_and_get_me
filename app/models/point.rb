class Point < ActiveRecord::Base
  belongs_to :tracksegment
  
  def self.find_with_sample_rate(rate = nil)
    valid_window = window_valid(rate) ? rate : APP_CONFIG["moving_average_window"]
    #points = find(:all, :conditions =>["mod(points.position, #{valid_rate}) = ? ", 0])
    points = find(:all)
    if (distance / points.length) < APP_CONFIG["lowest_sample_rate"]
      new_points = MovingAverage.track_smoothning(points, valid_window.to_i)
    end
    distance
    new_points.blank? ? points : new_points
  end
  
  def self.distance
    unless @distance
      @distance = GpsCalculation.get_distance_in_meters(find(:all))
    end
    @distance
  end
  
  WINDOW = [1, 3, 5, 7, 9]
  
  def self.window_valid(rate)
    WINDOW.include?(rate.to_i) ? true : false
  end
  
end
