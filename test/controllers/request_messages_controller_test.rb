require 'test_helper'

class RequestMessagesControllerTest < ActionController::TestCase
  setup do
    @request_message = request_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:request_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create request_message" do
    assert_difference('RequestMessage.count') do
      post :create, request_message: {  }
    end

    assert_redirected_to request_message_path(assigns(:request_message))
  end

  test "should show request_message" do
    get :show, id: @request_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @request_message
    assert_response :success
  end

  test "should update request_message" do
    patch :update, id: @request_message, request_message: {  }
    assert_redirected_to request_message_path(assigns(:request_message))
  end

  test "should destroy request_message" do
    assert_difference('RequestMessage.count', -1) do
      delete :destroy, id: @request_message
    end

    assert_redirected_to request_messages_path
  end
end
