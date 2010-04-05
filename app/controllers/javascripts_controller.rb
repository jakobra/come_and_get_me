class JavascriptsController < ApplicationController

  def load_all_tracks
    @race_tracks = RaceTrack.find(:all, :order => :title)
  end
  
end
