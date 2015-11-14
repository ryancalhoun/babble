class Chain < ActiveRecord::Base
  validates :word, :uniqueness => { :scope => :previous }

  def self.get_random_word
    return unless count > 0
    min_id = minimum(:id).to_i
    max_id = where.not(:is_punct => true).last.id

    where.not(:is_punct => true).where(['id >= ?', min_id + rand(max_id - min_id + 1)]).first
  end

  def self.get_random_next_word(word)
    id = where(:previous => word).pluck(:id).sample
    find id if id
  end

end
