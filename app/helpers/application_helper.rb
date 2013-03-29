module ApplicationHelper
  def loading_div
    content_tag :div, :class => "loader" do
      image_tag "icons/ajax-loader(2).gif", :class => "spinner"
    end
  end
  
  def display_readable_time(times = {})
    (times.map { |time| "#{t("datetime.time."+time[0], :count => time[1])}" unless time.blank?}).join(" ")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    child_index = "new_#{association}_#{f.object.hash}"
    fields = f.fields_for(association, new_object, :child_index => child_index) do |builder|
      if builder.object.class.to_s == "Race"
        builder.object.build_note
      end
      render(association.to_s.pluralize + "/" + association.to_s.singularize + "_fields", :f => builder)
    end
    fields.gsub!(child_index, "{{=index}}")
    raw("#{link_to(name, nil, :class => "add_fields")} #{render_as_javascript_template fields, association}")
  end
  
  def render_as_javascript_template(content, association)
    "<script id=\"#{association.to_s.singularize}_form_template\" type=\"text/template\">#{content}</script>"
  end
  
  def info_tag(info)
    image_tag "icons/info_icon.png", :class => "info", :title => info
  end
  
  def render_html_content(page)
    unless page.style.blank?
      head_content = ["<style type=\"text/css\" media=\"screen\">", page.style, "</style>"]
      content_for :head do
      	head_content.join.html_safe
      end
    end
    RedCloth.new(page.content).to_html.html_safe
  end
  
  def render_side_module_html(side_module)
    result = "<div class=\"side_module\">"
    result += render_html_content side_module
    result += "<div class=\"bottom\"></div></div>"
    result.html_safe
  end
  
  def error_messages(entity)
    unless entity.errors.any?
      return
    end
    render :partial => "application/error_messages", :locals => {:entity => entity, :text_resource => text_resource(entity)}
  end
  
  def text_resource(entity)
    text_resource = t("activerecord.models.#{entity.class.name.underscore}.one")
    text_resource.nil? ? entity.class.name.underscore.humanize : text_resource
  end
end