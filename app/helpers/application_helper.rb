# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def loading_div
    content_tag :div, :class => "modalbox_content" do
      image_tag "icons/ajax-loader(2).gif", :class => "spinner"
    end
  end
  
  def display_readable_time(times = {})
    (times.map { |time| "#{t("datetime.time."+time[0], :count => time[1])}" unless time.blank?}).join(" ")
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
  
  def render_html_content(page)
    unless page.style.blank?
      head_content = ["<style type=\"text/css\" media=\"screen\">", page.style, "</style>"]
      content_for :head do
      	head_content.join 
      end
    end
    RedCloth.new(page.content).to_html
  end
    
end