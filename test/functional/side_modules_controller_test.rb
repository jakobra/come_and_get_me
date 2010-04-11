require 'test_helper'

class SideModulesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => SideModule.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    SideModule.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    SideModule.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to side_module_url(assigns(:side_module))
  end
  
  def test_edit
    get :edit, :id => SideModule.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    SideModule.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SideModule.first
    assert_template 'edit'
  end
  
  def test_update_valid
    SideModule.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SideModule.first
    assert_redirected_to side_module_url(assigns(:side_module))
  end
  
  def test_destroy
    side_module = SideModule.first
    delete :destroy, :id => side_module
    assert_redirected_to side_modules_url
    assert !SideModule.exists?(side_module.id)
  end
end
