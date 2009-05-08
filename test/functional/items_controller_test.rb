require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Item.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Item.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Item.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to item_url(assigns(:item))
  end
  
  def test_edit
    get :edit, :id => Item.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Item.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Item.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Item.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Item.first
    assert_redirected_to item_url(assigns(:item))
  end
  
  def test_destroy
    item = Item.first
    delete :destroy, :id => item
    assert_redirected_to items_url
    assert !Item.exists?(item.id)
  end
end
