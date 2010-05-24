class TabService
  
  attr_reader :tabs, :content
  
  def initialize(current, content, tabs)
    @tabs = tabs
    @current = current
    @content = content
    @key_position = 0
    @current_position = 0
  end
  
  def left_class(key)
    tab_class = "tab"
    tab_class += "_current" if key == @current
    tab_class += "_left"
    if key == tabs.first
      tab_class += "_start start_end"
    else
      tab_class += right_of_current(key) ? "_current middle" : " middle"
    end
    tab_class
  end
  
  def tab_class(key)
    key == @current ? "tab_current" : "tab"
  end
  
  def right_class(key)
    tab_class = "tab"
    tab_class += "_current" if key == @current
    tab_class += "_right"
    if key == tabs.last
      tab_class += "_end start_end"
    else
      tab_class += left_of_current(key) ? "_current middle" : " middle"
    end
    tab_class
  end
  
  private
  
  def left_of_current(key)
    positions(key)
    @key_position + 1 == @current_position
  end
  
  def right_of_current(key)
    positions(key)
    @key_position - 1 == @current_position
  end
  
  def positions(key)
    tabs.each_with_index do |tab, index|
      if tab == key
        @key_position = index
      end
      if tab == @current
        @current_position = index
      end
    end
  end
  
end
