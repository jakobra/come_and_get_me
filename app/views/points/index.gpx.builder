xml.instruct! :xml, :version=>"1.0", :standalone => "no"
xml.gpx("xmlns" => "http://www.topografix.com/GPX/1/1", :creator => "Come And Get Me" , :version => "1.1", "xmlns:xsi" => "http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd"){
  xml.trk do |trk|
    trk.name @track.name
    trk.desc nil
    @track.tracksegments.each do |tracksegment|
      trk.trkseg do |trkseg|
        tracksegment.points.find_with_sample_rate(params[:rate]).each do |point|
          trkseg.trkpt(:lat => point.latitude, :lon => point.longitude) do |trkpt|
            trkpt.ele point.elevation
          end
        end
      end
    end
  end
}