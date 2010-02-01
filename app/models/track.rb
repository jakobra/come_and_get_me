class Track < ActiveRecord::Base
  require "rexml/document"
  
  has_many :tracksegments, :dependent => :destroy
  has_many :points, :through => :tracksegments
  has_many :races
  
  has_attached_file :track,
                    :url => "/assets/:class/:id_:basename.:extension",
                    :path => ":rails_root/public/assets/:class/:id_:basename.:extension"
                    
  validates_format_of :track_file_name, 
                      :with => %r{\.(gpx|kml)$}i, 
                      :message => ("must be a GPX or KML file")
  
  attr_accessor :file_handler, :track_document, :tmp_segment, :tmp_point
  
  def save_attached_files_with_parse_file
    save_attached_files_without_parse_file
    parse_file
  end
  
  alias_method_chain :save_attached_files, :parse_file
  
  def parse_file
    prepare_track_file
    parse_gpx
    cleanup_track_file
  end
  
  def prepare_track_file
    logger.info "Prepare track file ..."
    make_file_handler
    open_track_file
  end
  
  def make_file_handler
    logger.info "Make file handler ..."
    self.file_handler = File.new(File.join(RAILS_ROOT, "public", track.url.split("?")[0]), "r")
  end
  
  def open_track_file
    logger.info "Open Track file ..."
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
      tmp_segment = Tracksegment.new
      self.tracksegments << tmp_segment
      node.each_element do |node|
        parse_points(node, tmp_segment)
      end
      tmp_segment.start_time = tmp_segment.points.first.point_created_at
      tmp_segment.end_time = tmp_segment.points.last.point_created_at
      tmp_segment.save
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
        tmp_point.name = node.text.to_s if node.name.eql? "name"
        tmp_point.elevation = node.text.to_s if node.name.eql? "ele"
        tmp_point.description = node.text.to_s if node.name.eql? "desc"
        tmp_point.point_created_at = node.text.to_s if node.name.eql? "time"
      end
      tmp_point.position = tmp_segment.points.size + 1
      tmp_segment.points << tmp_point
    end
  end
  
  def cleanup_track_file
    self.file_handler.close
  end
end