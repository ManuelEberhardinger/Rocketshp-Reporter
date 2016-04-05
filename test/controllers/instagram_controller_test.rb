require 'test_helper'

class InstagramControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :redirect
  end

  test "should get login_page" do
    get :login_page
    assert_response :success
  end

end
