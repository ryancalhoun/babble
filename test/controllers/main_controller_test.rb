require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "get sentence" do

    w1 = Word.create(WordBuilder.new('Hello').to_h)
    w2 = Word.create(WordBuilder.new('!').to_h)

    Chain.create :word => w1
    Chain.create :word => w2, :prev_word => w1
    get :create_sentence
    assert_equal 'Hello!', @response.body
  end
  test "post sentence" do
    post :parse_sentence, :text => "Hello, world! How now brown cow?"
    assert_response :accepted
  end
end
