class String
  def to_uri
    uri_string = self.dup
    uri_string.gsub!(/[ÄäÅå]+/,'a')
    uri_string.gsub!(/[Öö]+/,'o') 
    uri_string.downcase!
    uri_string.gsub!(/, +/,'_')
    uri_string.gsub!(/[\s]+/,'_')
    uri_string.gsub!(/[\(\)]+/,'')
    uri_string.gsub!(/[^a-z0-9,._]+/, '-')
    uri_string.gsub!(/(^[-]+|[-]+$)/, '')
    #uri_string = CGI::escape(uri_string)
    uri_string
  end
end