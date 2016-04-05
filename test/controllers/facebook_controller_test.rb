require 'test_helper'

class FacebookControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :redirect
  end

end
