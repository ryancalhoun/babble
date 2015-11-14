class Markov

  END_PUNCT = /[.!\?]/

  def initialize(model)
    @model = model
  end

  def create_sentence
    w = @model.get_random_word
    return unless w
    s = w.word.capitalize
    until w.is_end?
      w = @model.get_random_next_word(w.word)
      break unless w
      s << ' ' unless w.is_punct?
      s << w.word
    end
    s
  end

  def parse!(text)
    text.scan(/\w+(?:'\w+)?|[[:punct:]]/).inject(nil) {|prev,word|
      @model.create opts(prev, word)
      word
    }
  end

  private
  def opts(prev, word)
    {
      :previous => prev =~ END_PUNCT ? nil : prev,
      :word     => word,
      :is_punct => !! (word =~ /^\W/),
      :is_end   => !! (word =~ END_PUNCT),
    }
  end

end
