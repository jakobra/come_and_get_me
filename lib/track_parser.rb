module TrackParser
  require 'tempfile'
  attr_accessor :file_handler, :track_document, :tmp_segment, :tmp_point
  
  def parse_gpx_file(track)
    logger.info "Initilize TrackParser ..."
    @track = track
    prepare_track_file
    parse_gpx
    cleanup_track_file
  end
  
  private
  
  def prepare_track_file
    Rails.logger.info "Prepare track file ..."
    make_file_handler
    open_track_file
  end
  
  def make_file_handler
    Rails.logger.info "Make file handler ..."
    self.file_handler = @track.file
  end
  
  def open_track_file
    Rails.logger.info "Open Track file ..."
    self.track_document = REXML::Document.new self.file_handler
  end
  
  def parse_gpx
    self.track_document.root.each_element do |node|
      parse_tracks(node)
    end
  end
  
  def parse_tracks(node)
    if node.name.eql? "trk"
      node.each_element do |node|
        parse_track_segments(node)
      end
    end
  end
  
  def parse_track_segments(node)
    if node.name.eql? "trkseg"
      tmp_segment = @track.tracksegments.create(:track_version => @track.version)
      node.each_element do |node|
        parse_points(node, tmp_segment)
      end
    end
  end
  
  def parse_points(node, tmp_segment)
    if node.name.eql? "trkpt"
      tmp_point = Point.new
      node.attributes.each do |key, value|
        tmp_point.latitude = value if key.eql? "lat"
        tmp_point.longitude = value if key.eql? "lon"
      end
      node.each_element do |node|
        tmp_point.elevation = node.text.to_s if node.name.eql? "ele"
      end
      tmp_segment.points << tmp_point
    end
  end
  
  def cleanup_track_file
    self.file_handler.close
  end
end