class Race < ActiveRecord::Base
  belongs_to :event
  belongs_to :training
  belongs_to :track
  attr_accessor :new_event_name, :new_event_description
  before_validation :create_event_from_name
  
  validates_presence_of :distance, :event
  validates_numericality_of :max_pulse, :avg_pulse, :allow_nil => true, :less_than => 250, :only_integer => true
  
  
  def create_event_from_name
    build_event(:name => new_event_name, :description => new_event_description) unless new_event_name.blank?
  end
  
end
