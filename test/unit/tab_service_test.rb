require 'test_helper'

class TabServiceTest < ActiveSupport::TestCase
  
  def test_class_of_current_tab
    assert_equal "tab_current_left_start start_end", tab_service.left_class(:all)
    assert_equal "tab_current", tab_service.tab_class(:all)
    assert_equal "tab_current_right middle", tab_service.right_class(:all)
  end
  
  def test_class_of_ladies_tab
    assert_equal "tab_left_current middle", tab_service.left_class(:ladies)
    assert_equal "tab", tab_service.tab_class(:ladies)
    assert_equal "tab_right middle", tab_service.right_class(:ladies)
  end
  
  def test_class_of_mens_tab
    assert_equal "tab_left middle", tab_service.left_class(:men)
    assert_equal "tab", tab_service.tab_class(:men)
    assert_equal "tab_right_end start_end", tab_service.right_class(:men)
  end
  
  private
  
  def tab_service
    tabs = [:all, :ladies, :men]
    TabService.new(:all, "hello", tabs)
  end
end
