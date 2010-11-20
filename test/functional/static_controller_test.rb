require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "should get wiki" do
    get :wiki
    assert_response :success
  end

  test "should get study" do
    get :study
    assert_response :success
  end

end
