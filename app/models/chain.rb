class Chain < ActiveRecord::Base
  validates :word, :uniqueness => { :scope => :previous }

  def self.get_random_word
    min_id = min
    where('id >= ?', min_id + rand(max - min_id)).first
  end

  def self.get_random_next_word(word)
    find where(:previous => word).pluck(:id).sample
  end

  private
  def self.min
    minimum(:id).to_i
  end
  def self.max
    maximum(:id).to_i
  end
end
