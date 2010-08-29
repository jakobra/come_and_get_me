class Race < ActiveRecord::Base
  belongs_to :event, :include => true
  belongs_to :training
  belongs_to :track
  
  has_one :user, :through => :training
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_one :note, :as => :noteable, :dependent => :destroy

  accepts_nested_attributes_for :note, :allow_destroy => true, :reject_if => lambda { |a| a[:content].blank? }
  
  attr_accessor :new_event_name, :new_event_description
  before_validation :create_event_from_name
  
  validates_presence_of :distance, :time_string, :event_id
  validates_numericality_of :hr_max, :hr_avg, :allow_nil => true, :less_than => 250, :only_integer => true
  validates_numericality_of :distance
  validates_format_of :time_string, :with => /^\d{2}:\d{2}:\d{2}$/, :message => "must be in format of hh:mm:ss", :unless => Proc.new { |user| user.time.blank? }
  
  EPOCH = 946684800
  
  def self.personal_bests(options = {})
    tracks = minimum(:time, :group => :track_id, :conditions => ["track_id IS NOT NULL"])
    logger.info "options #{options.inspect}"
    races = []
    tracks.each do |track|
      races << find(:first, options.merge(:order => "trainings.date DESC", :conditions => ["track_id = ? AND time = ?", track[0], track[1]], :include => [:track, :training]))
    end
    races.sort {|a, b| b.training.date <=> a.training.date}
  end
  
  def self.recent_records(gender = nil)
    if gender.nil?
      self.records(:limit => 5)
    else
      self.records({:limit => 5}, gender)
    end
  end
  
  def self.records(options = {}, gender = nil)
    if gender.nil?
      tracks = minimum(:time, :group => :track_id, :conditions => ["track_id IS NOT NULL"])
    else
      tracks = minimum(:time, :group => :track_id, :conditions => ["track_id IS NOT NULL AND users.gender = ?", gender], :joins => {:training => :user})
    end
 
    begin
      find_all_by_time(tracks.values, options.merge(:order => "trainings.date DESC", :joins => :training))
    rescue
      # Having an rescue so that we don´t run join training twice, don´t know a better way
      find_all_by_time(tracks.values, options.merge(:order => "trainings.date DESC"))
    end
  end
  
  def time_string
    if @time_string.blank?
      time.blank? ? "" : time.strftime("%H:%M:%S")
    else
      @time_string
    end
  end
  
  def title
    self.training.date.strftime("%e %b - %Y")
  end
  
  def time_string=(time_str)
    @time_string = time_str
    self.time = time_str.blank? ? nil : Time.parse(time_str)
  rescue ArgumentError
  end
  
  def create_event_from_name
    create_event(:name => new_event_name, :description => new_event_description) unless new_event_name.blank?
  end
  
  def time_per_km
    seconds_per_km = (self.time.to_i - EPOCH) / self.distance
    time = Time.at(seconds_per_km + EPOCH)
    time.getgm
  end
  
  def to_param
    if(!self.event.blank?)
      "#{self.id}-#{self.event.name}".to_uri
    else
      self.id.to_s
    end
  end
  
end