module TracksHelper
  
  def readable_time_difference(difference)
    seconds    =  difference % 60
    difference = (difference - seconds) / 60
    minutes    =  difference % 60
    difference = (difference - minutes) / 60
    hours      =  difference % 24
    difference = (difference - hours)   / 24
    days       =  difference #% 7
    #weeks      = (difference - days)    /  7
    attributes = ["days", "hours", "m", "s"]
    values = [days.to_i, hours.to_i, minutes.to_i, seconds.to_i]
    result = ""
    values.each_with_index do |value, index|
      result += "#{value} #{attributes[index]} " unless value.eql? 0
    end
    result
  end
end
