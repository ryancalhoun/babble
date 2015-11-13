require 'test_helper'

class ChainTest < ActiveSupport::TestCase
  test "get next word" do
    Chain.create :word=>'dog', :previous=>'the'
    assert_equal 'dog', Chain.find_by(:previous=>'the').word
  end
  test "unique entries" do
    assert Chain.create(:word=>'dog', :previous=>'the').save
    assert ! Chain.create(:word=>'dog', :previous=>'the').save
  end
end
