require 'markov'

class MarkovTest < Test::Unit::TestCase
  class ::String
    def is_punct?
      self =~ /[,.!?]/
    end
    def is_end?
      self =~ /[.!?]/
    end
    def word
      self
    end
  end
  class CreateModel
    def initialize(words)
      @words = words
    end
    def get_random_word
      @words.shift
    end
    def get_random_next_word(word)
      @words.shift
    end
  end

  def testCreateSentence
    model = CreateModel.new %w(Hello , world ! How now , brown cow ?)
    markov = Markov.new model
    assert_equal "Hello, world!", markov.create_sentence
    assert_equal "How now, brown cow?", markov.create_sentence
  end

  def testCreateSentenceWithIncomplete
    model = CreateModel.new %w(Hello , world)
    markov = Markov.new model
    assert_equal "Hello, world", markov.create_sentence
  end

  def testCreateSentenceCapitalization
    model = CreateModel.new %w(hello , world)
    markov = Markov.new model
    assert_equal "Hello, world", markov.create_sentence
  end

  class ParseModel
    attr_reader :opts
    def create(opts)
      (@opts ||= []) << opts
    end
  end

  def testParse
    model = ParseModel.new
    markov = Markov.new model
    markov.parse! "Hello, world! How now, brown cow?"

    assert_equal [
      {:word=>'Hello', :previous=>nil,     :is_punct=>false, :is_end=>false},
      {:word=>',',     :previous=>'Hello', :is_punct=>true,  :is_end=>false},
      {:word=>'world', :previous=>',',     :is_punct=>false, :is_end=>false},
      {:word=>'!',     :previous=>'world', :is_punct=>true,  :is_end=>true},
      {:word=>'How',   :previous=>nil,     :is_punct=>false, :is_end=>false},
      {:word=>'now',   :previous=>'How',   :is_punct=>false, :is_end=>false},
      {:word=>',',     :previous=>'now',   :is_punct=>true,  :is_end=>false},
      {:word=>'brown', :previous=>',',     :is_punct=>false, :is_end=>false},
      {:word=>'cow',   :previous=>'brown', :is_punct=>false, :is_end=>false},
      {:word=>'?',     :previous=>'cow',   :is_punct=>true,  :is_end=>true},
    ], model.opts
  end

end
