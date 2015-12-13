require 'test_helper'

class AgendueCalendarControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get ics" do
    get :ics
    assert_response :success
  end

end
