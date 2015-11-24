require 'test_helper'

class ChainTest < ActiveSupport::TestCase

  test "get next word" do
    Chain.create :word_id=>42, :prev_word_id=>43
    assert_equal 42, Chain.find_by(:prev_word_id=>43).word_id
  end

  test "unique entries" do
    assert Chain.create(:word_id=>42, :prev_word_id=>43).save
    assert ! Chain.create(:word_id=>42, :prev_word_id=>43).save
  end

  def self.random_values
    @@random_values
  end

  test "random next word" do
    begin
      @@random_values = [2,0]
      Array.send(:alias_method, :orig_sample, :sample)
      Array.send(:define_method, :sample) {
        self[ChainTest.random_values.shift]
      }
      w = Word.create(:value=>'the')
      %w(dog cat mouse horse).each {|word|
        Chain.create(:word=>Word.create(:value=>word), :prev_word=>w).save
      }
  
      assert_equal 'mouse', Chain.get_random_next_word(w).word.value
      assert_equal 'dog', Chain.get_random_next_word(w).word.value
    ensure
      Array.send(:alias_method, :sample, :orig_sample)
      Array.send(:remove_method, :orig_sample)
    end
  end
end
