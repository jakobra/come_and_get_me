require 'rubygems'
require 'active_record'

require 'db_connection.rb'

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
    tracksegment.points.each_with_index do |point, index|
      point.position = index + 1
      point.save
      k += 1
    end
  end
end

puts "#{k} points updated"