require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Blogs.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Blogs.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Blogs.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to blogs_url(assigns(:blogs))
  end
  
  def test_edit
    get :edit, :id => Blogs.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Blogs.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Blogs.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Blogs.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Blogs.first
    assert_redirected_to blogs_url(assigns(:blogs))
  end
  
  def test_destroy
    blogs = Blogs.first
    delete :destroy, :id => blogs
    assert_redirected_to blogs_url
    assert !Blogs.exists?(blogs.id)
  end
end
