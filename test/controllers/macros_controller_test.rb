require 'test_helper'

class MacrosControllerTest < ActionController::TestCase
  test "should get eliminar" do
    get :eliminar
    assert_response :success
  end

end
