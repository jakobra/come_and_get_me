require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => "mysql",
  :host => "localhost",
  :database => "race_training_development",
  :password => "always",
  :username => "root"
)

class Point < ActiveRecord::Base
  belongs_to :tracksegment
end

class Tracksegment < ActiveRecord::Base
  has_many :points
  belongs_to :track
end

class Track < ActiveRecord::Base
  has_many :tracksegments
  has_many :points, :through => :tracksegments
end

tracks = Track.find(:all)

k = 0
for track in tracks
  track.tracksegments.each do |tracksegment|
    tracksegment.start_time = tracksegment.points.first.point_created_at
    tracksegment.end_time = tracksegment.points.last.point_created_at
    tracksegment.save
    k += 1
  end
end

puts "#{k} segments updated"