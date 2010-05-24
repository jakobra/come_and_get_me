module SideModules
  
  def local_tracks
    @area = County.find_by_geolocation(request.remote_ip)
    @area = @area.municipalities.find_by_geolocation(request.remote_ip) unless @area.blank?
  end
  
  def last_races
    @last_races = Race.find(:all, :order => "Id DESC", :limit => 3)
  end
  
  def recent_records(current = :all)
    tabs = [:all, :ladies, :men]
    if !tabs.include?(current)
      current = :all
    end
    
    if (current != :all)
      recent_records = (current == :ladies) ? Race.recent_records(1) : Race.recent_records(0)
    else
      recent_records = Race.recent_records
    end
    @recent_records_tab_service = TabService.new(current, recent_records, tabs)
  end
end