require 'test_helper'

class InvoiceControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

end
