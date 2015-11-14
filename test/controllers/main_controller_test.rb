require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "get sentence" do
    Chain.create :word => 'Hello'
    Chain.create :word => '!', :previous => 'Hello', :is_punct => true, :is_end => true
    get :create_sentence
    assert_equal 'Hello!', @response.body
  end
  test "post sentence" do
    post :parse_sentence, :text => "Hello, world! How now brown cow?"
    assert_response :accepted
  end
end
