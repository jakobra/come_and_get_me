class SideModuleResolver
  @current_menu_node
  
  def initialize(current_menu_node)
    @current_menu_node = current_menu_node
  end
  
  def left_side
    render_side_module(@current_menu_node.menu_node_side_modules.left_before)
  end
  
  def right_side
    render_side_module(@current_menu_node.menu_node_side_modules.right_before)
  end
  
  def head
    head = content_for_head(@current_menu_node.menu_node_side_modules.left_before)
    head += content_for_head(@current_menu_node.menu_node_side_modules.right_before)
    head
  end
  
  private
  
  def render_side_module(side_modules)
    content_for_right_side = ""
    side_modules.each do |menu_node_side_module|
      content_for_right_side += render_html_content_to_string menu_node_side_module.side_module
    end
    content_for_right_side.html_safe
  end
  
  def content_for_head(side_modules)
    content = ""
    side_modules.each do |item|
      unless item.side_module.style.blank?
        head_content = ["<style type=\"text/css\" media=\"screen\">", item.side_module.style, "</style>"]
        content += head_content.join
      end
    end
    content.html_safe
  end
  
  def render_html_content_to_string(item)
    result = "<div class=\"side_module\">"
    result += RedCloth.new(item.content).to_html
    result += "<div class=\"bottom\"></div></div>"
  end
end