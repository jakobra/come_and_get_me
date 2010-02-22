class Track < ActiveRecord::Base
  require "rexml/document"
  include TrackParser
  
  has_many :tracksegments, :dependent => :destroy, :conditions => 'track_version = #{self.send(:tracksegment_version)}'
  has_many :points, :through => :tracksegments
  has_many :races
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  belongs_to :created_by_user, :class_name => "User"
  belongs_to :municipality
  
  before_destroy :destroy_all_tracksegments
  
  has_attached_file :track,
                    :url => "/assets/:class/:id_:version_:basename.:extension",
                    :path => ":rails_root/public/assets/:class/:id_:version_:basename.:extension",
                    :keep_old_files => true
                    
  validates_format_of :track_file_name, 
                      :with => %r{\.(gpx)$}i, 
                      :message => ("must be a GPX"),
                      :unless => Proc.new { |track| track.track_file_name.blank? }
  
  validates_presence_of :municipality, :name
  
  versioned
  
  attr_accessor :circle
  
  def save_attached_files_with_parse_file
    dirty = track.dirty?
    save_attached_files_without_parse_file
    if dirty
      parse_file(self)
      set_finish_point if circle
    end
  end
        
  alias_method_chain :save_attached_files, :parse_file
  
  def title
    name
  end
  
  def tracksegment_version
    result = nil
    Tracksegment.find(:all, :conditions => ["track_id = ?", self.id], :order => "track_version DESC").each do |tracksegment|
      logger.info "Track_version: #{tracksegment.track_version}"
      result = tracksegment.track_version <= version ? tracksegment.track_version : nil
      break unless result.nil?
    end
    result.nil? ? 1 : result
  end
  
  private
  
  def destroy_all_tracksegments
    Tracksegment.destroy_all(:track_id => self.id)
  end
  
  def set_finish_point
    logger.info "Version: #{self.version}"
    self.reload
    lp = points.first
    tracksegments.last.points.create(:longitude => lp.longitude, 
                                    :latitude => lp.latitude, 
                                    :elevation => lp.elevation)
    logger.info "Finish point appended"
  end
  
end