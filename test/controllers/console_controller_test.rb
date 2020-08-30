require 'test_helper'

class ConsoleControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get input" do
    get :input
    assert_response :success
  end

end
