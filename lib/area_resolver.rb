class AreaResolver
  @name
  @ip_name
  
  def initialize(name, ip_name)
    @name = name
    @ip_name = ip_name
  end
  
  def match?
    translated_name = translated(@name)
    if @name == @ip_name
      return false
    elsif translated_name == @ip_name
      return false
    elsif remove_lan(translated_name) == @ip_name
      return false
    else
      return true
    end
  end
  
  private
  
  def translated(area)
    area = area.gsub(/Ö/, 'O')
    area = area.gsub(/ö/, 'o')
    area = area.gsub(/[ÅÄ]/, 'A')
    area = area.gsub(/[åä]/, 'a')
  end
  
  def remove_lan(name)
    if name.match(/Lan$/)
      if name[0..-5].match(/s$/)
        return name[0..-6]
      else
        return name[0..-5]
      end
    else
      return name
    end
  end
  
end