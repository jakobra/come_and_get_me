class Track < ActiveRecord::Base
  require "rexml/document"
  include TrackParser
  
  has_many :tracksegments, :dependent => :destroy
  has_many :points, :through => :tracksegments
  has_many :races
  has_many :tagings
  has_many :tags, :through => :tagings
  
  belongs_to :created_by_user, :class_name => "User"
  belongs_to :municipality
  
  accepts_nested_attributes_for :tracksegments, :allow_destroy => true, :reject_if => lambda { |a| a[:points_attributes].blank? }
  
  before_destroy :clean_up
  after_save :assign_tags, :parse_file
                    
  validates_format_of :file_name, 
    :with => %r{\.(gpx)$}i, 
    :message => (I18n.translate("activerecord.errors.messages.must_be", :name => I18n.translate("activerecord.attributes.track.gpx_file"))),
    :unless => Proc.new { |track| track.file_name.blank? }
  
  validates_presence_of :municipality_id, :title
  validates_numericality_of :distance
  
  attr_writer :tag_names
  attr_accessor :circle # Boolean attributes, same_start_and_finish point
  
  scope :latest, order("id DESC").limit(5)
  
  def file=(file)
    if !file.nil?
      self.file_name = file.original_filename.sanitize
      self.file_type = file.content_type
      self.file_size = file.size
      self.file_content = File.open(file.path,"rb") {|io| io.read}
      file.close
    else
      self.file_name = nil
      self.file_type = nil
      self.file_size = nil
      self.file_content = nil
    end
  end
  
  def file
    path = File.join(RAILS_ROOT, APP_CONFIG['track_path'])
    Dir.mkdir(path) unless File.directory?(path)
    File.open(File.join(path, current_file_name), 'w') {|f| f.write(file_content) }
    File.open(File.join(path, current_file_name), 'r')
  end
  
  def tag_names
    @tag_names || tags.map(&:name).join(", ")
  end
  
  def records(conditions = {})
    races.find(:all, :order => "time", :limit => 20, :include => [:event, {:training => :user}], :conditions => conditions)
  end
  
  def record
    races.find(:first, :order => "time", :include => [:event, {:training => :user}])
  end
  
  def current_file_name
    "#{self.id}.#{self.version}.#{self.file_name}"
  end
  
  def parse_file
    unless self.file_name.blank?
      parse_gpx_file(self)
      set_finish_point
    end
  end
    
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
  
  def to_param
    "#{self.id}-#{self.title}".to_uri
  end
  
  private
  
  def clean_up
    tracksegments = Tracksegment.find(:all, :conditions => {:track_id => self.id})
    tracksegments.each { |seg| seg.destroy }
    FileUtils.rm_rf File.join(RAILS_ROOT, APP_CONFIG['track_path'])
  end
  
  # Appends a gps point so that a track starts and stops at the same position if user choosen so through :circle
  def set_finish_point
    self.reload
    if circle == "1"
      lp = points.first
      tracksegments.last.points.create(:longitude => lp.longitude, 
                                      :latitude => lp.latitude, 
                                      :elevation => lp.elevation)
      logger.info "Finish point appended"
    end
  end
  
  def assign_tags
    if @tag_names
      self.tags = @tag_names.split(/,/).map do |name|
        Tag.find_or_create_by_name(name.strip)
      end
    end
  end  
end