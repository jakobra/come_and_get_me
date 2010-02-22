class RaceTrackSegment < ActiveRecord::Base
  belongs_to :track
  belongs_to :race_track
  
  validates_presence_of :track_id, :quantity
end
