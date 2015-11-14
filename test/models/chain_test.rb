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

  def self.random_values
    @@random_values
  end
  test "random word" do
    begin
      @@random_values = [2,0]
      Chain.send(:define_singleton_method, :rand) {|max|
        ChainTest.random_values.shift
      }
      %w(dog cat mouse horse).each {|word|
        Chain.create :word=>word, :previous=>'the'
      }
      assert_equal 'mouse', Chain.get_random_word.word
      assert_equal 'dog', Chain.get_random_word.word
    ensure
      class << Chain
        remove_method :rand
      end
    end
  end

  test "random next word" do
    begin
      @@random_values = [2,0]
      Array.send(:alias_method, :orig_sample, :sample)
      Array.send(:define_method, :sample) {
        self[ChainTest.random_values.shift]
      }
      %w(dog cat mouse horse).each {|word|
        Chain.create(:word=>word, :previous=>'the').save
      }
      assert_equal 'mouse', Chain.get_random_next_word('the').word
      assert_equal 'dog', Chain.get_random_next_word('the').word
    ensure
      Array.send(:alias_method, :sample, :orig_sample)
      Array.send(:remove_method, :orig_sample)
    end
  end
end
