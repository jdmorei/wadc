require 'test_helper'

class TelnetControllerTest < ActionController::TestCase
  test "should get terminal" do
    get :terminal
    assert_response :success
  end

  test "should get input_command" do
    get :input_command
    assert_response :success
  end

  test "should get output_command" do
    get :output_command
    assert_response :success
  end

end
