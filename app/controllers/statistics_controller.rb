class StatisticsController < ApplicationController
  def race_track_records
    unless params[:id].blank?
      @statistics = Race.all(:conditions => ["race_track_id = ?", params[:id]], :order => "time", :limit => 10)
      flash[:error] = "No records found" if @statistics.blank?
    end
  end

end
