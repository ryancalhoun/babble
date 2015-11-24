require 'markov'

class MarkovTest < Test::Unit::TestCase
  class ChainWrapper
    def initialize(word)
      @word = word
    end
    def word
      @word
    end
  end
  class CreateWordsModel
    def initialize(words)
      @words = words
    end
    def get_random_word
      WordBuilder.new @words.shift
    end
  end
  class CreateChainsModel
    def initialize(words)
      @words = words
    end
    def get_random_next_word(word)
      w = @words.shift
      w ? ChainWrapper.new(WordBuilder.new(w)) : nil
    end
  end

  def testCreateSentence
    words = CreateWordsModel.new %w(Hello How)
    chains = CreateChainsModel.new %w(, world ! now , brown cow ?)
    markov = Markov.new words, chains
    assert_equal "Hello, world!", markov.create_sentence
    assert_equal "How now, brown cow?", markov.create_sentence
  end

  def testCreateSentenceWithIncomplete
    words = CreateWordsModel.new %w(Hello)
    chains = CreateChainsModel.new %w(, world)
    markov = Markov.new words, chains
    assert_equal "Hello, world", markov.create_sentence
  end

  def testCreateSentenceCapitalization
    words = CreateWordsModel.new %w(hello)
    chains = CreateChainsModel.new %w(, world)
    markov = Markov.new words, chains
    assert_equal "Hello, world", markov.create_sentence
  end

  class ParseWordsModel
    attr_reader :opts
    def where(opts)
      (@opts ||= []) << opts
      w = WordBuilder.new opts.value
      def w.first_or_create
        value ? self : nil
      end
      w
    end
  end
  class ParseChainsModel
    attr_reader :opts
    def create(opts)
      (@opts ||= []) << opts
    end
  end

  def testParse
    words = ParseWordsModel.new
    chains = ParseChainsModel.new
    markov = Markov.new words, chains
    markov.parse! "Hello, world! How now, brown cow?"

    assert_equal [
      {:value=>'Hello', :punct=>false, :end_of_sentence=>false},
      {:value=>'Hello', :punct=>false, :end_of_sentence=>false},
      {:value=>',', :punct=>true, :end_of_sentence=>false},
      {:value=>',', :punct=>true, :end_of_sentence=>false},
      {:value=>'world', :punct=>false, :end_of_sentence=>false},
      {:value=>'world', :punct=>false, :end_of_sentence=>false},
      {:value=>'!', :punct=>true, :end_of_sentence=>true},
      {:value=>'!', :punct=>true, :end_of_sentence=>true},
      {:value=>'How', :punct=>false, :end_of_sentence=>false},
      {:value=>'How', :punct=>false, :end_of_sentence=>false},
      {:value=>'now', :punct=>false, :end_of_sentence=>false},
      {:value=>'now', :punct=>false, :end_of_sentence=>false},
      {:value=>',', :punct=>true, :end_of_sentence=>false},
      {:value=>',', :punct=>true, :end_of_sentence=>false},
      {:value=>'brown', :punct=>false, :end_of_sentence=>false},
      {:value=>'brown', :punct=>false, :end_of_sentence=>false},
      {:value=>'cow', :punct=>false, :end_of_sentence=>false},
      {:value=>'cow', :punct=>false, :end_of_sentence=>false},
      {:value=>'?', :punct=>true, :end_of_sentence=>true},
    ], words.opts

    assert_equal [
      {:word=>WordBuilder.new('Hello'), :prev_word=>nil},
      {:word=>WordBuilder.new(','),     :prev_word=>WordBuilder.new('Hello')},
      {:word=>WordBuilder.new('world'), :prev_word=>WordBuilder.new(',')},
      {:word=>WordBuilder.new('!'),     :prev_word=>WordBuilder.new('world')},
      {:word=>WordBuilder.new('How'),   :prev_word=>nil},
      {:word=>WordBuilder.new('now'),   :prev_word=>WordBuilder.new('How')},
      {:word=>WordBuilder.new(','),     :prev_word=>WordBuilder.new('now')},
      {:word=>WordBuilder.new('brown'), :prev_word=>WordBuilder.new(',')},
      {:word=>WordBuilder.new('cow'),   :prev_word=>WordBuilder.new('brown')},
      {:word=>WordBuilder.new('?'),     :prev_word=>WordBuilder.new('cow')},
    ], chains.opts
  end

end
