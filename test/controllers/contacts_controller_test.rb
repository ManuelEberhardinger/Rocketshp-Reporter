require 'test_helper'

class ContactsControllerTest < ActionController::TestCase
  setup do
    @contact = contacts(:one)
    @company = companies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create contact" do
    assert_difference('Contact.count') do
      post :create, contact: { company_id: @company.id, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, mobile: @contact.mobile, phone: @contact.phone }
    end

    assert_redirected_to @company
  end

  test "should show contact" do
    get :show, id: @contact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @contact
    assert_response :success
  end

  test "should update contact" do
    patch :update, id: @contact, contact: { company_id: @company.id, email: @contact.email, first_name: @contact.first_name, last_name: @contact.last_name, mobile: @contact.mobile, phone: @contact.phone }
    assert_redirected_to @company
  end

  test "should destroy contact" do
    assert_difference('Contact.count', -1) do
      delete :destroy, id: @contact
    end

    assert_redirected_to contacts_path
  end
end
