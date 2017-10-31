require 'test_helper'

class CancellationMessagesControllerTest < ActionController::TestCase
  setup do
    @cancellation_message = cancellation_messages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cancellation_messages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cancellation_message" do
    assert_difference('CancellationMessage.count') do
      post :create, cancellation_message: {  }
    end

    assert_redirected_to cancellation_message_path(assigns(:cancellation_message))
  end

  test "should show cancellation_message" do
    get :show, id: @cancellation_message
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cancellation_message
    assert_response :success
  end

  test "should update cancellation_message" do
    patch :update, id: @cancellation_message, cancellation_message: {  }
    assert_redirected_to cancellation_message_path(assigns(:cancellation_message))
  end

  test "should destroy cancellation_message" do
    assert_difference('CancellationMessage.count', -1) do
      delete :destroy, id: @cancellation_message
    end

    assert_redirected_to cancellation_messages_path
  end
end
