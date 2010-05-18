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
      if content_for_right_side.blank?
        content_for_right_side += render_html_content_to_string menu_node_side_module.side_module
      else
        content_for_right_side += render_html_content_to_string menu_node_side_module.side_module
      end
    end
    content_for_right_side
  end
  
  def content_for_head(side_modules)
    content = ""
    side_modules.each do |item|
      unless item.side_module.style.blank?
        head_content = ["<style type=\"text/css\" media=\"screen\">", item.side_module.style, "</style>"]
        if content.blank?
          content = head_content.join
        else
          content += head_content.join
        end
      end
    end
    content
  end
  
  def render_html_content_to_string(item)
    result = "<div class=\"side_module\">"
    result += RedCloth.new(item.content).to_html
    result += "<div class=\"bottom\"></div></div>"
  end
end