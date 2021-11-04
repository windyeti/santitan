require 'test_helper'

class AbcsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get abcs_index_url
    assert_response :success
  end

  test "should get show" do
    get abcs_show_url
    assert_response :success
  end

  test "should get edit" do
    get abcs_edit_url
    assert_response :success
  end

  test "should get update" do
    get abcs_update_url
    assert_response :success
  end

end
