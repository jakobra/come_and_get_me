module TracksHelper
    
  def if_high_sample_rate(track, &block)
    if (track.points.distance / track.points.size) < APP_CONFIG["lowest_sample_rate"]
      concat capture(&block)
    end
  end
  
  def track_created_from(track)
    if track.file_name.blank?
      "Plot"
    else
      link_to "#{h(track.file_name)} (GPX)", track_file_path(:id => track.id, :file_name => track.file_name)
    end
  end

end
