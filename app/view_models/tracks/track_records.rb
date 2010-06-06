class TrackRecords
  
  attr_reader :track, :event, :races, :gender
  
  def initialize(track, event, races, gender)
    @track = track
    @event = event
    @races = races
    @gender = gender
  end
  
end