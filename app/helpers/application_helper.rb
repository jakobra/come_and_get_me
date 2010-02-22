# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def loading_div
    content_tag :div, :class => "modalbox_content" do
      image_tag "icons/ajax-loader(2).gif", :class => "spinner"
    end
  end
  
  def display_readable_time(times = {})
    (times.map { |time| "#{pluralize(time[1], time[0])}" }).join(" ")
  end
  
  def admin_menu(&block)
    if admin?
      content_for :admin_menu do
        content_tag :div, capture(&block), :id => "admin_menu"
      end
    end
  end
  
end