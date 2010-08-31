class TracksContainer
  
  attr_reader :tracks, :county, :municipality, :municipalities, :latest_tracks
  
  def initialize(tracks, county, municipality, municipalities, latest_tracks)
    @tracks = tracks
    @county = county
    @municipality = municipality
    @municipalities = municipalities
    @latest_tracks = latest_tracks
  end
  
end