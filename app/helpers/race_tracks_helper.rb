module RaceTracksHelper
  
  def add_race_track_segment_field_link(name)
    link_to_function name do |page|
  		page.insert_html :bottom, :race_track_segments, :partial => "race_track_segment_field", :object => RaceTrackSegment.new
  	end
  end
  
end
