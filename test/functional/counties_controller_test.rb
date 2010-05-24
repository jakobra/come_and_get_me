require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => County.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    #assert_template 'new'
    assert_redirected_to new_session_path
  end
  
  def test_create_invalid
    County.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_redirected_to new_session_path
  end
  
  def test_create_valid
    County.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to new_session_path
    #assert_redirected_to county_url(assigns(:county))
  end
  
  def test_edit
    get :edit, :id => County.first
    #assert_template 'edit'
    assert_redirected_to new_session_path
  end
  
  def test_update_invalid
    County.any_instance.stubs(:valid?).returns(false)
    put :update, :id => County.first
    #assert_template 'edit'
    assert_redirected_to new_session_path
  end
  
  def test_update_valid
    County.any_instance.stubs(:valid?).returns(true)
    put :update, :id => County.first
    #assert_redirected_to county_url(assigns(:county))
    assert_redirected_to new_session_path
  end
  
  def test_destroy
    county = County.first
    delete :destroy, :id => county
    assert_redirected_to new_session_path
    #assert_redirected_to counties_url
    assert County.exists?(county.id)
  end
end
