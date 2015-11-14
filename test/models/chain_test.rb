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
  test "punctuation" do
    Chain.create :word=>',', :is_punct => true
    Chain.create :word=>'.', :is_punct => true, :is_end => true
    assert Chain.find_by(:word=>[',', '.']).is_punct? 
    assert Chain.find_by(:word=>'.').is_end? 
  end
end
