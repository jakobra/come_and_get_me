module SideModules
  
  def local_race_tracks
    @area = County.find_by_geolocation(request.remote_ip)
    @area = @area.municipalities.find_by_geolocation(request.remote_ip) unless @area.blank?
  end
  
  def last_race
    @last_race = Race.find(:last)
  end
  
  def recent_records
    @recent_records = Race.recent_records
  end
  
end