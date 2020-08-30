require 'test_helper'

class InterfacesControllerTest < ActionController::TestCase
  setup do
    @interface = interfaces(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:interfaces)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create interface" do
    assert_difference('Interface.count') do
      post :create, interface: { address: @interface.address, dns: @interface.dns, gateway: @interface.gateway, mask: @interface.mask, name: @interface.name }
    end

    assert_redirected_to interface_path(assigns(:interface))
  end

  test "should show interface" do
    get :show, id: @interface
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @interface
    assert_response :success
  end

  test "should update interface" do
    patch :update, id: @interface, interface: { address: @interface.address, dns: @interface.dns, gateway: @interface.gateway, mask: @interface.mask, name: @interface.name }
    assert_redirected_to interface_path(assigns(:interface))
  end

  test "should destroy interface" do
    assert_difference('Interface.count', -1) do
      delete :destroy, id: @interface
    end

    assert_redirected_to interfaces_path
  end
end
