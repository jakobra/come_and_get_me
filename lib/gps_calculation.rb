module GpsCalculation
  require 'mathn'
  
  def self.get_distance_in_meters(points)
    distances = []
    points.each_with_index do |point, index|
      if index != points.length-1
        distance = get_distance_between_points(point, points[index+1])
      else
        distance = get_distance_between_points(point, points[0])
      end
      distances << distance
    end
    (eval distances.join('+')).to_i
  end
  
  def self.get_distance_between_points(point_a, point_b)
    gps_to_meters(point_a.latitude, point_a.longitude, point_b.latitude, point_b.longitude)
  end
  
  def self.gps_to_meters(lat_a, lng_a, lat_b, lng_b)
    to_radians = Math::PI / 180.0
    earth_radius_km = 6371.0 # Eart radius in kilometers
    earth_radius_m = 6366000 # Eart radius in meters
    
    d_lat = (lat_a-lat_b) * to_radians
    d_lon = (lng_a-lng_b) * to_radians
    lat1 = lat_a * to_radians
    lat2 = lat_b * to_radians
    
    a = Math::sin(d_lat/2) * Math::sin(d_lat/2) + Math::cos(lat1) * Math::cos(lat2) * Math::sin(d_lon/2) * Math::sin(d_lon/2)
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    earth_radius_m * c
  end
end