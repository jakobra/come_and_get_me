class Track < ActiveRecord::Base
  require "rexml/document"
  include TrackParser
  
  has_many :tracksegments, :dependent => :destroy, :conditions => 'track_version = #{self.send(:tracksegment_version)}'
  has_many :points, :through => :tracksegments
  has_many :races
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  belongs_to :created_by_user, :class_name => "User"
  belongs_to :municipality
  
  accepts_nested_attributes_for :tracksegments, :allow_destroy => true, :reject_if => lambda { |a| a[:points_attributes].blank? }
  
  before_destroy :destroy_all_tracksegments
  after_create :create_race_track
  
  has_attached_file :track,
                    :url => "/assets/:class/:id_:version_:basename.:extension",
                    :path => ":rails_root/public/assets/:class/:id_:version_:basename.:extension",
                    :keep_old_files => true
                    
  validates_format_of :track_file_name, 
                      :with => %r{\.(gpx)$}i, 
                      :message => (I18n.translate("activerecord.errors.messages.must_be", :name => "en GPX-fil")),
                      :unless => Proc.new { |track| track.track_file_name.blank? }
  
  validates_presence_of :municipality_id, :title
  
  validates_presence_of :tracksegments, :if  => Proc.new { |track| track.track_file_name.blank? }
  
  # Versioned by vestal versions
  versioned
  
  # Boolean attributes, same_start_and_finish and wheather create a race_track or not 
  attr_accessor :circle, :new_race_track
  
  named_scope :latest, {:limit => 5, :order => "id DESC"}
  
  def save_attached_files_with_parse_file
    dirty = track.dirty?
    save_attached_files_without_parse_file
    if dirty
      parse_file(self)
      set_finish_point if circle == "1"
    end
  end
  
  alias_method_chain :save_attached_files, :parse_file
    
  def tracksegment_version
    result = nil
    Tracksegment.find(:all, :conditions => ["track_id = ?", self.id], :order => "track_version DESC").each do |tracksegment|
      result = tracksegment.track_version <= version ? tracksegment.track_version : nil
      break unless result.nil?
    end
    result.nil? ? 1 : result
  end
  
  private
  
  # Appends a gps point so that a track starts and stops at the same position if user choosen so through :circle
  def set_finish_point
    self.reload
    lp = points.first
    tracksegments.last.points.create(:longitude => lp.longitude, 
                                    :latitude => lp.latitude, 
                                    :elevation => lp.elevation)
    logger.info "Finish point appended"
  end
  
  # Creates new race_track if user choosen so through :new_race_track
  def create_race_track
    if new_race_track == "1"
      race_track = RaceTrack.new({:title => title, :description => description, :municipality_id => municipality_id})
      race_track.created_by_user_id = created_by_user_id
      race_track.race_track_segments.build({:track_id => id, :quantity => 1})
      race_track.save
    end
  end
  
end