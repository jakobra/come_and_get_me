module SideModules
  
  def local_tracks
    @area = County.find_by_geolocation(request.remote_ip)
    @area = @area.municipalities.find_by_geolocation(request.remote_ip) unless @area.blank?
  end
  
  def last_races
    @last_races = Race.find(:all, :order => "Id DESC", :limit => 3)
  end
  
  def recent_records
    @recent_records = Race.recent_records
  end
  
  def mens_recent_records
    @mens_recent_records = Race.recent_records(0)
  end
  
  def ladies_recent_records
    @ladies_recent_records = Race.recent_records(1)
  end
end