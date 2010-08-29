# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title)
    @content_for_title = page_title.to_s
  end
  
  def description(page_description)
    @content_for_description = page_description.to_s
  end
  
  def canonical(page_canonical)
    @content_for_canonical = page_canonical.to_s
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  
  def main_class(main_class = nil)
    @class = main_class.blank? ? "large_width": main_class
  end
end
