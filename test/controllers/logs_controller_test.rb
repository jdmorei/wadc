require 'test_helper'

class LogsControllerTest < ActionController::TestCase
  test "should get readLog" do
    get :readLog
    assert_response :success
  end

end
