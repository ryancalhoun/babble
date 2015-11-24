class Chain < ActiveRecord::Base
  validates :word_id, :uniqueness => { :scope => :prev_word_id }

  belongs_to :word
  belongs_to :prev_word, :class_name => 'Word'

  def self.get_random_next_word(word)
    id = where(:prev_word => word).pluck(:id).sample
    find id if id
  end

end
