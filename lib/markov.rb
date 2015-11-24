require_relative 'word_builder'

class Markov

  def initialize(words, chains)
    @words, @chains = words, chains
  end

  def create_sentence
    w = @words.get_random_word
    return unless w
    s = w.value.capitalize
    until w.end_of_sentence?
      n = @chains.get_random_next_word(w)
      break unless n
      w = n.word
      s << ' ' unless w.punct?
      s << w.value
    end
    s
  end

  def parse!(text)
    text.scan(/\w+(?:'\w+)?|[[:punct:]]/).inject(nil) {|prev,word|
      if prev
        prev = WordBuilder.new prev
        prev = @words.where(prev).first_or_create
      end

      word = WordBuilder.new word
      word = @words.where(word).first_or_create

      @chains.create chain_opts(prev, word)
      word.value
    }
  end

  private

  def chain_opts(prev, word)
    {
      :word      => word,
      :prev_word => (prev.nil? || prev.end_of_sentence?) ? nil : prev,
    }
  end

end
