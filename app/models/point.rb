class Point < ActiveRecord::Base
  belongs_to :tracksegment
  
  def self.find_with_sample_rate(rate = nil)
    valid_rate = rate_valid(rate) ? rate : 5
    find(:all, :conditions =>["mod(points.position, #{valid_rate}) = ? ", 0])
  end
  
  RATES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  
  def self.rate_valid(rate)
    if RATES.include?(rate.to_i)
      true
    else
      false
    end
  end
  
end
