require 'test_helper'

class AppControllerTest < ActionDispatch::IntegrationTest
  test "should get test" do
    get app_test_url
    assert_response :success
  end

end
