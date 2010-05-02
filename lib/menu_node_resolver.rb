class MenuNodeResolver
  
  attr_reader :current_menu_node
  
  def initialize(request)
    path = request.path
    if request.post?
      path = path + "/new"
    elsif request.put?
      path = path + "/update"
    end
    
    MenuNode.all.each do |menu_node|
      if /^#{menu_node.side_module_regex}$/ =~ path
        @current_menu_node = menu_node
        break
      end
    end
    
    @current_menu_node = MenuNode.find_by_url("default") if @current_menu_node.blank?
  end
end