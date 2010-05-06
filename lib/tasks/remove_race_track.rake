namespace :race_track_migration do
  task :create_track_from_race_track => :environment do
    race_tracks = RaceTrack.all
    i = 0
    race_tracks.each do |race_track|
      if race_track.tracks.size < 2
        if race_track.tracks.blank?
          new_track = Track.new(:title => race_track.title,
                                :track_file_name => nil,
                                :track_content_type => nil,
                                :track_file_size => nil,
                                :description => race_track.description,
                                :date => Date.today,
                                :municipality_id => race_track.municipality_id,
                                :created_by_user_id => race_track.created_by_user_id)
          new_track.save(false)
          r_t_s = race_track.race_track_segments.build(:track_id => new_track.id, :quantity => 1)
          r_t_s.save(false)
        
        else race_track.tracks.blank?
          t = race_track.tracks.first
          new_track = Track.new(:title => race_track.title,
                                :track_file_name => t.track_file_name,
                                :track_content_type => t.track_content_type,
                                :track_file_size => t.track_file_size,
                                :description => t.description + "\n\n" + race_track.description,
                                :date => t.date,
                                :municipality_id => t.municipality_id,
                                :created_by_user_id => t.created_by_user_id)
          new_track.save(false)
      
          unless new_track.track_file_name.blank?
            require 'ftools'
            File.copy("#{RAILS_ROOT}/public/assets/tracks/#{t.id}_#{t.tracksegment_version}_#{t.track_file_name}", "#{RAILS_ROOT}/public/assets/tracks/#{new_track.id}_1_#{new_track.track_file_name}")
          end
        
          r_t_s = race_track.race_track_segments.build(:track_id => new_track.id, :quantity => 1)
          r_t_s.save(false)
        
          t.tracksegments.each do |seg|
            track_seg = new_track.tracksegments.build(:track_version => seg.track_version)
            seg.points.each do |point|
              track_seg.points.build(:longitude => point.longitude, :latitude => point.latitude, :elevation => point.elevation)
            end
            track_seg.save(false)
          end
        end
        puts race_track.title + "\t"
        puts "One track" + "\n" 
        i += 1
      end
    end
    puts i.to_s + " has one or less tracks of " + race_tracks.length.to_s
    puts "done"
  end

  task :remove_race_track_segments => :environment do
    race_tracks = RaceTrack.all
    i = 0
    race_tracks.each do |race_track|
      race_track.race_track_segments.each { |r_t_s| r_t_s.destroy unless r_t_s == race_track.race_track_segments.last }
      i += 1
    end
    puts i.to_s + " has been processed of " + race_tracks.length.to_s
    puts "done"
  end
  
  task :remove_unused_tracks => :environment do
     tracks_to_keep = RaceTrack.all.map { |rt| rt.tracks.last }
     puts "Race Tracks #{RaceTrack.all.length}"
     puts "Tracks to keep #{tracks_to_keep.length}"
     puts "Tracks total #{Track.all.length}"
     Track.all.each { |t| t.destroy unless tracks_to_keep.include?(t) }
     puts "Tracks to keep #{Track.all.length}"
  end
  
  task :move_tags => :environment do
    i = 0
    RaceTrack.all.each do |rt|
      rt.tagings.each do |t|
        t.race_track_id = rt.tracks.last.id
        t.save
        i += 1
      end
    end
    puts i.to_s + " tags has been processed"
    puts "done"
  end
  
  task :update_races => :environment do
    i = 0
    Race.all.each do |r|
      unless r.race_track.blank?
        t_id = r.race_track.tracks.last.id
        r.race_track_id = t_id
        r.save(false)
        i += 1
      end
    end
    puts i.to_s + " races has been updated"
    puts "done"
  end
end