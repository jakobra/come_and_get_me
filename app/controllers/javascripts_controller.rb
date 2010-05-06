class JavascriptsController < ApplicationController

  def load_all_tracks
    @tracks = Track.find(:all, :order => :title)
  end
  
end
