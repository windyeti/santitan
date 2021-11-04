require 'test_helper'

class VisitorsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get visitors_index_url
    assert_response :success
  end

  test "should get manual" do
    get visitors_manual_url
    assert_response :success
  end

  test "should get mail_test" do
    get visitors_mail_test_url
    assert_response :success
  end

end
