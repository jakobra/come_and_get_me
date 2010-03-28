ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  if instance.error_message.kind_of?(Array)
    "<span class=\"fieldWithErrors\">#{html_tag}</span>"
  else
    "<span class=\"fieldWithErrors\">#{html_tag}</span>"
  end
end