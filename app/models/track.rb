class Track < ActiveRecord::Base
  require "rexml/document"
  include TrackParser
  
  has_many :tracksegments, :dependent => :destroy, :conditions => 'track_version = #{self.send(:tracksegment_version)}'
  has_many :points, :through => :tracksegments
  has_many :races
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :tagings
  has_many :tags, :through => :tagings
  
  belongs_to :created_by_user, :class_name => "User"
  belongs_to :municipality
  
  accepts_nested_attributes_for :tracksegments, :allow_destroy => true, :reject_if => lambda { |a| a[:points_attributes].blank? }
  
  before_destroy :destroy_all_tracksegments
  
  has_attached_file :track,
                    :url => "/assets/:class/:id_:version_:basename.:extension",
                    :path => ":rails_root/public/assets/:class/:id_:version_:basename.:extension",
                    :keep_old_files => true
                    
  validates_format_of :track_file_name, 
                      :with => %r{\.(gpx)$}i, 
                      :message => (I18n.translate("activerecord.errors.messages.must_be", :name => "en GPX-fil")),
                      :unless => Proc.new { |track| track.track_file_name.blank? }
  
  validates_presence_of :municipality_id, :title
  
  # Versioned by vestal versions
  versioned
  
  # Boolean attributes, same_start_and_finish point
  attr_accessor :circle
  
  named_scope :latest, {:limit => 5, :order => "id DESC"}
  
  def records(conditions = {})
    races.find(:all, :order => "time", :limit => 20, :include => [:event, {:training => :user}], :conditions => conditions)
  end
  
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
  
  def events
    races.find(:all, :select => 'DISTINCT event_id', :include => :event).map { |race| race.event }
  end
  
  private
  
  def destroy_all_tracksegments
    tracksegments = Tracksegment.find(:all, :conditions => {:track_id => self.id})
    tracksegments.each { |seg| seg.destroy }
  end
  
  # Appends a gps point so that a track starts and stops at the same position if user choosen so through :circle
  def set_finish_point
    self.reload
    lp = points.first
    tracksegments.last.points.create(:longitude => lp.longitude, 
                                    :latitude => lp.latitude, 
                                    :elevation => lp.elevation)
    logger.info "Finish point appended"
  end
  
end