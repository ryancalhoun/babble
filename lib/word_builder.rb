class WordBuilder < Hash
  END_PUNCT = /[.!\?]/

  def initialize(word)
    self[:value] = word
    self[:punct] = !! (word =~ /^\W/)
    self[:end_of_sentence] = !! (word =~ END_PUNCT)
  end

  def value
    self[:value]
  end

  def to_s
    self[:value]
  end

  def punct?
    self[:punct]
  end

  def end_of_sentence?
    self[:end_of_sentence]
  end
end
