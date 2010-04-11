require 'test_helper'

class MenuNodesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => MenuNode.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    MenuNode.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    MenuNode.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to menu_node_url(assigns(:menu_node))
  end
  
  def test_edit
    get :edit, :id => MenuNode.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    MenuNode.any_instance.stubs(:valid?).returns(false)
    put :update, :id => MenuNode.first
    assert_template 'edit'
  end
  
  def test_update_valid
    MenuNode.any_instance.stubs(:valid?).returns(true)
    put :update, :id => MenuNode.first
    assert_redirected_to menu_node_url(assigns(:menu_node))
  end
  
  def test_destroy
    menu_node = MenuNode.first
    delete :destroy, :id => menu_node
    assert_redirected_to menu_nodes_url
    assert !MenuNode.exists?(menu_node.id)
  end
end
