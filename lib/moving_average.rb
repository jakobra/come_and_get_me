module MovingAverage
  
  def self.track_smoothning(track_points, window)
    points = []
    center = (window / 2).ceil
    size = track_points.size
    track_points.each_with_index do |point, index|
      if (index < (center + 1)) || (index > (size - center))
        points << point
      else
        points << average(track_points[(index - center + 1), window])
      end
    end
    points
  end
  
  def self.average(window_points)
    latitudes = window_points.map { |p| p.latitude }
    longitudes = window_points.map { |p| p.longitude }
    point_index = (window_points.size / 2).ceil
    window_points[point_index-1].latitude = (latitudes.sum / latitudes.size)
    window_points[point_index-1].longitude = (longitudes.sum / longitudes.size)
    window_points[point_index-1]
  end
  
end