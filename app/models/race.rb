class Race < ActiveRecord::Base
  belongs_to :event
  belongs_to :training
  belongs_to :race_track
  
  has_one :user, :through => :training
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  attr_accessor :new_event_name, :new_event_description
  before_validation :create_event_from_name
  
  validates_presence_of :distance, :event_id
  validates_numericality_of :hr_max, :hr_avg, :allow_nil => true, :less_than => 250, :only_integer => true
  validates_format_of :time_string, :with => /^\d{2}:\d{2}:\d{2}$/, :message => "must be in format of hh:mm:ss", :unless => Proc.new { |user| user.time.blank? }
  
  def self.personal_bests(options = {})
    race_tracks = calculate(:min, :time, :group => "race_track_id", :conditions => "race_track_id IS NOT NULL")
    from_times(race_tracks.values, options)
  end
  
  def self.recent_records
    self.records(:limit => 5)
  end
  
  def self.records(options = {})
    race_tracks = find_by_sql("SELECT min(`races`.time) AS min_time, race_track_id AS race_track_id FROM `races` INNER JOIN `trainings` ON `races`.training_id = `trainings`.id WHERE (race_track_id IS NOT NULL) GROUP BY race_track_id")
    #race_tracks = calculate(:min, :time, :group => "race_track_id", :conditions => "race_track_id IS NOT NULL")
    
    from_times(race_tracks.map { |race_track| race_track['min_time']}, options)
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
    build_event(:name => new_event_name, :description => new_event_description) unless new_event_name.blank?
  end
  
  private
  
  def self.from_times(times, options)
    with_scope :find => options do
      begin
        find_all_by_time(times, :order => "trainings.date DESC", :joins => :training)
      rescue
        # Having an rescue so that we don´t run join training twice, don´t know a better way
        find_all_by_time(times, :order => "trainings.date DESC")
      end
    end
  end
  
end