class Race < ActiveRecord::Base
  belongs_to :event
  belongs_to :training
  belongs_to :race_track
  
  has_one :user, :through => :training
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessor :new_event_name, :new_event_description
  before_validation :create_event_from_name
  
  validates_presence_of :distance, :event
  validates_numericality_of :hr_max, :hr_avg, :allow_nil => true, :less_than => 250, :only_integer => true
  validates_format_of :time_string, :with => /^\d{2}:\d{2}:\d{2}$/, :message => "must be in format of hh:mm:ss"
  
  def self.recent_records
    race_tracks = calculate(:min, :time, :group => "race_track_id", :conditions => "race_track_id IS NOT NULL", :include => :training)
    find_all_by_time(race_tracks.values, :order => "trainings.date DESC", :joins => :training, :limit => 5)
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
    self.time = Time.parse(time_str)
  rescue ArgumentError
  end
  
  def create_event_from_name
    build_event(:name => new_event_name, :description => new_event_description) unless new_event_name.blank?
  end
  
end