xml.instruct!
xml.kml("xmlns" => "http://www.opengis.net/kml/2.2"){
  xml.Document do |doc|
    doc.name @track.name
    doc.open 1
    doc.Style do |style|
      style.LineStyle do |line_style|
        line_style.color "7f0000ff"
        line_style.width 6
      end
    end
    doc.description "n/a"
    @track.tracksegments.each_with_index do |tracksegment, index|
      doc.Placemark do |placemark|
        placemark.styleUrl "#trailsstyle"
        placemark.name "#{@track.name}: Segment (#{index+1})"
        placemark.LineString do |line_string|
          line_string.tessellate 1
          coordinates = ""
          tracksegment.points.find_with_sample_rate(params[:rate]).each do |point|
            coordinates << "#{point.longitude},#{point.latitude},#{point.elevation}\n"
          end
          line_string.coordinates coordinates
        end
      end
    end
  end
}