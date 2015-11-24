require 'word_builder'

class WordBuilderTest < Test::Unit::TestCase

  def testWord
    w = WordBuilder.new 'foo'

    assert_equal 'foo', w.to_s
    assert_false w.punct?
    assert_false w.end_of_sentence?

    assert Hash === w

    assert_equal ({
      :value => 'foo',
      :punct => false,
      :end_of_sentence => false,
    }), w

  end

  def testPunctuation
    w = WordBuilder.new ','

    assert_equal ',', w.to_s
    assert_true w.punct?
    assert_false w.end_of_sentence?

    assert Hash === w

    assert_equal ({
      :value => ',',
      :punct => true,
      :end_of_sentence => false,
    }), w

  end

  def testPunctuationEndOfSentence
    w = WordBuilder.new '.'

    assert_equal '.', w.to_s
    assert_true w.punct?
    assert_true w.end_of_sentence?

    assert Hash === w

    assert_equal ({
      :value => '.',
      :punct => true,
      :end_of_sentence => true,
    }), w

  end
end
