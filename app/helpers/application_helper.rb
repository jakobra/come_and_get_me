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
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end
    link_to_function(name, h("add_fields(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
  end
  
  def info_tag(info)
    image_tag "icons/info_icon.png", :class => "info", :title => info
  end
    
end