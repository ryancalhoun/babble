require 'test_helper'

class WordTest < ActiveSupport::TestCase

  test "unique entries" do
    assert Word.create(:value=>'dog').save
    assert ! Word.create(:value=>'dog').save
  end

  test "punctuation" do
    Word.create :value=>',', :punct => true
    Word.create :value=>'.', :punct => true, :end_of_sentence => true
    assert Word.find_by(:value=>[',', '.']).punct? 
    assert Word.find_by(:value=>'.').end_of_sentence? 
  end

  def self.random_values
    @@random_values
  end

  test "random word" do
    begin
      @@random_values = [2,0]
      Word.send(:define_singleton_method, :rand) {|max|
        WordTest.random_values.shift
      }
      %w(dog cat mouse horse).each {|word|
        Word.create(:value=>word).save
      }
      assert_equal 'mouse', Word.get_random_word.value
      assert_equal 'dog', Word.get_random_word.value
    ensure
      class << Word
        remove_method :rand
      end
    end
  end
end
