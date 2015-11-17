class Chain < ActiveRecord::Base
  validates :word, :uniqueness => { :scope => :previous }

  def self.get_random_next_word(word)
    id = where(:previous => word).pluck(:id).sample
    find id if id
  end

end
