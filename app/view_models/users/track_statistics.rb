class TrackStatistics
  
  attr_reader :races, :chart_races, :chart_races_count, :track
  
  def initialize(races, chart_races, chart_races_count, track)
    @races = races
    @chart_races = chart_races
    @chart_races_count = chart_races_count
    @track = track
  end
  
end